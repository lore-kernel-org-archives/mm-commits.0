Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77592370AC9
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067209; cv=none; b=BAt5fTm+B7Yx3kU6ZHKVS77QxMJIWk+gVl8wfXnG9tnpjX6LCZGbI1jOoQ45bzGZsvhNOa6jO+IxLAid/VkZalQEdcQIcsytvcYckCqMYnTnbd4GLg/pKuckDpfdCmAX9LrKy3lfO53x+kGFVDy0VtUHYxwOlYMqNsmTzjdWTuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067209; c=relaxed/simple;
	bh=B8pmv9CPcd71NwgW+0hDyV2zr1lIhOEcC4ZqWlizbVs=;
	h=Date:To:From:Subject:Message-Id; b=SeDpwfOfxlfcdBvrcMIkG/EHbkiosmaQApsdZ0ORGoD+p0w38eqsQ7yWc35I20N7pKXQjFFpdZx8NrTn2wcFy+rczhkIc5Ty0UMsAKSz/3EVy7IR4m80HkM1WPLOPyfcSgML88cQyxHX+bkgmSb2P8fq1AcZuEkav91bkZsj8ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qQ77mEdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qQ77mEdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C90C1F000E9;
	Sun, 21 Jun 2026 18:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067208;
	bh=bqnXXZaEhAS8istExq7qHKhwmC4AQ+uHR04n7Vcxlkw=;
	h=Date:To:From:Subject;
	b=qQ77mEdwZZS8OtwEMMEmDuciY3sKC+/LS+IPUWmaOQzkAbgOVQe5WtGWc9m7guszm
	 21ChxQkk+I4luqCfXR3QyW9y6lyz6E5zAQncc8SSCnymF4woyUWahSHRrfKK0XFiJj
	 FvsuWDrcpfFpQHvOhWcEAeOoh6N0SnQYxx84qolU=
Date: Sun, 21 Jun 2026 11:40:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch removed from -mm tree
Message-Id: <20260621184008.4C90C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: move hwpoison setup into run_test() and silence modprobe output for memory-failure category
has been removed from the -mm tree.  Its filename was
     selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: move hwpoison setup into run_test() and silence modprobe output for memory-failure category
Date: Thu, 21 May 2026 12:17:52 +0530

run_vmtests.sh contains special handling to ensure the hwpoison_inject
module is available for the memory-failure tests.  This logic was
implemented outside of run_test(), making the setup category-specific but
managed globally.

Move the hwpoison_inject handling into run_test() and restrict it
to the memory-failure category so that:
1. the module is checked and loaded only when memory-failure tests run,
2. the test is skipped if the module or the debugfs interface
(/sys/kernel/debug/hwpoison/) is not available.
3. the module is unloaded after the test if it was loaded by the script.

This localizes category-specific setup and makes the test flow
consistent with other per-category preparations.

While updating this logic, fix the module availability check.
The script previously used:

        modprobe -R hwpoison_inject

The -R option prints the resolved module name to stdout, causing every
run to print:

        hwpoison_inject

in the test output, even when no action is required, introducing
unnecessary noise.

Replace this with:

        modprobe -n hwpoison_inject

which verifies that the module is loadable without producing output,
keeping the selftest logs clean and consistent.

Also, ensure that skipped tests do not override a previously recorded
failure.  A skipped test currently sets exitcode to ksft_skip even if a
prior test has failed, which can mask failures in the final exit status. 
Update the logic to only set exitcode to ksft_skip when no failure has
been recorded.

Link: https://lore.kernel.org/93441f34f7ef5add47d1a130d03daa79e21b5050.1779296493.git.sayalip@linux.ibm.com
Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   62 +++++++++++++-------
 1 file changed, 41 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -180,6 +180,9 @@ pretty_name() {
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
+		local skip=0
+		local LOADED_HWPOISON_INJECT_MOD=0
+
 		# On memory constrainted systems some tests can fail to allocate hugepages.
 		# perform some cleanup before the test for a higher success rate.
 		if [ ${CATEGORY} == "thp" -o ${CATEGORY} == "hugetlb" ]; then
@@ -194,13 +197,45 @@ run_test() {
 			fi
 		fi
 
+		# Ensure hwpoison_inject is available for memory-failure tests
+		if [ "${CATEGORY}" = "memory-failure" ]; then
+			# Try to load hwpoison_inject if not present.
+			HWPOISON_DIR=/sys/kernel/debug/hwpoison/
+			if [ ! -d "$HWPOISON_DIR" ]; then
+				if ! modprobe -n hwpoison_inject > /dev/null 2>&1; then
+					echo "Module hwpoison_inject not found, skipping..." \
+						| tap_prefix
+					skip=1
+				else
+					modprobe hwpoison_inject > /dev/null 2>&1
+					LOADED_HWPOISON_INJECT_MOD=1
+					if [ ! -d "$HWPOISON_DIR" ]; then
+						echo "hwpoison debugfs interface not present" \
+							| tap_prefix
+						skip=1
+					fi
+				fi
+			fi
+
+		fi
+
 		local test=$(pretty_name "$*")
 		local title="running $*"
 		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
 		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep" | tap_prefix
 
-                ("$@" 2>&1) | tap_prefix
-                local ret=${PIPESTATUS[0]}
+		if [ $skip -eq 1 ]; then
+			local ret=$ksft_skip
+		else
+			("$@" 2>&1) | tap_prefix
+			local ret=${PIPESTATUS[0]}
+		fi
+
+		# Unload hwpoison_inject if we loaded it
+		if [ "${LOADED_HWPOISON_INJECT_MOD}" = "1" ]; then
+			modprobe -r hwpoison_inject > /dev/null 2>&1
+		fi
+
 		count_total=$(( count_total + 1 ))
 		if [ $ret -eq 0 ]; then
 			count_pass=$(( count_pass + 1 ))
@@ -210,7 +245,9 @@ run_test() {
 			count_skip=$(( count_skip + 1 ))
 			echo "[SKIP]" | tap_prefix
 			echo "ok ${count_total} ${test} # SKIP" | tap_output
-			exitcode=$ksft_skip
+			if [ $exitcode -eq 0 ]; then
+				exitcode=$ksft_skip
+			fi
 		else
 			count_fail=$(( count_fail + 1 ))
 			echo "[FAIL]" | tap_prefix
@@ -422,24 +459,7 @@ CATEGORY="page_frag" run_test ./test_pag
 
 CATEGORY="rmap" run_test ./rmap
 
-# Try to load hwpoison_inject if not present.
-HWPOISON_DIR=/sys/kernel/debug/hwpoison/
-if [ ! -d "$HWPOISON_DIR" ]; then
-	if ! modprobe -q -R hwpoison_inject; then
-		echo "Module hwpoison_inject not found, skipping..."
-	else
-		modprobe hwpoison_inject > /dev/null 2>&1
-		LOADED_MOD=1
-	fi
-fi
-
-if [ -d "$HWPOISON_DIR" ]; then
-	CATEGORY="memory-failure" run_test ./memory-failure
-fi
-
-if [ -n "${LOADED_MOD}" ]; then
-	modprobe -r hwpoison_inject > /dev/null 2>&1
-fi
+CATEGORY="memory-failure" run_test ./memory-failure
 
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are


