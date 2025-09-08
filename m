Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B714C2F744C
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 23:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757373496; cv=none; b=ulexk231tRtJBThkA5FC3fdrKuX7tlHJL6aeJmn6D7lCQcHQCJNOAILgd8G1y4jfvwkEw6VMzvIu/ejHIGL7Bwma6O989M9GWybLiaqm3MhdhbMHunwEAqm+PRcdQE9p0DChT5YT+Pn6xkZo6dGZhenY4Kfbe3yBAH+zM+s1Gcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757373496; c=relaxed/simple;
	bh=4AbG0yzmvDhIi05obvH1b9Bq0bCUtIhN39Kbw1xEcKc=;
	h=Date:To:From:Subject:Message-Id; b=S8wAbIQ/pi7tLHRarHM47Xh2WFszO2NULRQmEozuItgGtyhfsCCDzfexPMMiNxV1bsHJt+3fDmGoyBMagvsmj3MxzBIXVzauL/wiS5wnLrd9P2SHssSJTYcZy+t/l8airc8ZaiuTbK/3me/5EoseWVjlpKhf8ELnbiQzoel5j6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f9yZFn6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f9yZFn6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2BEC4CEF1;
	Mon,  8 Sep 2025 23:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757373496;
	bh=4AbG0yzmvDhIi05obvH1b9Bq0bCUtIhN39Kbw1xEcKc=;
	h=Date:To:From:Subject:From;
	b=f9yZFn6eRu2m8F/4d25UE/UzsJ+9sbwLJ0N8YTXHsjjqxecwKFgAAosvD94o/p6TN
	 j72HxU4LTpDoKzs/72PHB1v13Gs1yMNu8/74wA53m+LSJndTEat9H7iUPQVMmcT5KH
	 O93Dw2MD67qFwX9riFszMUJ1LH30v5VJg0qqXYDk=
Date: Mon, 08 Sep 2025 16:18:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-alloc-hugepages-in-va_high_addr_switch-test.patch added to mm-new branch
Message-Id: <20250908231816.2E2BEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: alloc hugepages in va_high_addr_switch test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-alloc-hugepages-in-va_high_addr_switch-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-alloc-hugepages-in-va_high_addr_switch-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: alloc hugepages in va_high_addr_switch test
Date: Mon, 8 Sep 2025 20:47:38 +0800

Alloc hugepages in the test internally, so we don't fully rely on the
run_vmtests.sh.  If run_vmtests.sh does that great, free hugepages is
enough for being used to run the test, leave it as it is, otherwise setup
the hugepages in the test.

Save the original nr_hugepages value and restore it after test finish, so
leave a stable test envronment.

Link: https://lkml.kernel.org/r/20250908124740.2946005-3-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.sh |   37 ++++++++++++
 1 file changed, 37 insertions(+)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftests-mm-alloc-hugepages-in-va_high_addr_switch-test
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -9,6 +9,7 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
+orig_nr_hugepages=0
 
 skip()
 {
@@ -76,5 +77,41 @@ check_test_requirements()
 	esac
 }
 
+save_nr_hugepages()
+{
+	orig_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
+}
+
+restore_nr_hugepages()
+{
+	echo "$orig_nr_hugepages" > /proc/sys/vm/nr_hugepages
+}
+
+setup_nr_hugepages()
+{
+	local needpgs=$1
+	while read -r name size unit; do
+		if [ "$name" = "HugePages_Free:" ]; then
+			freepgs="$size"
+			break
+		fi
+	done < /proc/meminfo
+	if [ "$freepgs" -ge "$needpgs" ]; then
+		return
+	fi
+	local hpgs=$((orig_nr_hugepages + needpgs))
+	echo $hpgs > /proc/sys/vm/nr_hugepages
+
+	local nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+	if [ "$nr_hugepgs" != "$hpgs" ]; then
+		restore_nr_hugepages
+		skip "$0: no enough hugepages for testing"
+	fi
+}
+
 check_test_requirements
+save_nr_hugepages
+# 4 keep_mapped pages, and one for tmp usage
+setup_nr_hugepages 5
 ./va_high_addr_switch --run-hugetlb
+restore_nr_hugepages
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-fix-hugepages-cleanup-too-early.patch
selftests-mm-alloc-hugepages-in-va_high_addr_switch-test.patch
selftests-mm-fix-va_high_addr_switchsh-failure-on-x86_64.patch

