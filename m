Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547C92E7648
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 23:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757373495; cv=none; b=Xzw2AgwdH2KUgctCKERKq+AuA5vmpUsaeSeZBRZr7X8oi9ywhZ1hobKLAu9htdNatGBI9DGE5IX7aF8gfK/Bs6dAmI/UvlFMT45UNv2c5J1gFkbzd10lTs8/Q4ohwCu+LowjeZBpany/BRS9bL8LUfHWytuvSE/MKqrhilU6dmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757373495; c=relaxed/simple;
	bh=fgMcMgejfolxYvnArT/CORknZ3EtUdD8AGaBTbD7kTs=;
	h=Date:To:From:Subject:Message-Id; b=TcyvDt/lwbNfHHnALtWyvSia2U95cbP/VF05Je6zh9VnGdSFcw1hiOIdqF2G7Vc1v5OMDYdGtJPtlw8QgBXsMxkndTI9ZKazfoJVso6oX0LOB+C8FK71H0LbxYLMdzUgmisPqzTgc8VIdP6K/4HmIJkwohoVlpIsnJCnr8TgcOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wUVFw4Bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wUVFw4Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4342C4CEF1;
	Mon,  8 Sep 2025 23:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757373494;
	bh=fgMcMgejfolxYvnArT/CORknZ3EtUdD8AGaBTbD7kTs=;
	h=Date:To:From:Subject:From;
	b=wUVFw4BbcccXXnQidnEGaifoFbwjpNASXnjhVKEIm/GZtGI4VGm4Fsqq6je/UKVEs
	 jdl6vv6vYairkVp029lheyzNZVdpx/8mVnqs0Cz6jPpil0XB2MdNSxKgy5V02R4sK4
	 hueqiFYHBecTVvHZhibelLBbOTjhwfdzOJx4Lns4=
Date: Mon, 08 Sep 2025 16:18:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-hugepages-cleanup-too-early.patch added to mm-new branch
Message-Id: <20250908231814.C4342C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix hugepages cleanup too early
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-hugepages-cleanup-too-early.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-hugepages-cleanup-too-early.patch

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
Subject: selftests/mm: fix hugepages cleanup too early
Date: Mon, 8 Sep 2025 20:47:37 +0800

Patch series "Fix va_high_addr_switch.sh test failure", v2.

These three patches fix a va_high_addr_switch.sh test failure on x86_64.


This patch (of 3):

The nr_hugepgs variable is used to keep the original nr_hugepages at the
hugepage setup step at test beginning.  After userfaultfd test, a cleaup
is executed, both /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages and
/proc/sys//vm/nr_hugepages are reset to 'original' value before
userfaultfd test starts.

Issue here is the value used to restore /proc/sys/vm/nr_hugepages is
nr_hugepgs which is the initial value before the vm_runtests.sh runs, not
the value before userfaultfd test starts.  'va_high_addr_swith.sh' tests
runs after that will possibly see no hugepages available for test, and got
EINVAL when mmap(HUGETLB), making the result invalid.

And before pkey tests, nr_hugepgs is changed to be used as a temp variable
to save nr_hugepages before pkey test, and restore it after pkey tests
finish.  The original nr_hugepages value is not tracked anymore, so no way
to restore it after all tests finish.

Add a new variable orig_nr_hugepgs to save the original nr_hugepages, and
and restore it to nr_hugepages after all tests finish.  And change to use
the nr_hugepgs variable to save the /proc/sys/vm/nr_hugeages after
hugepage setup, it's also the value before userfaultfd test starts, and
the correct value to be restored after userfaultfd finishes.  The
va_high_addr_switch.sh broken will be resolved.

Link: https://lkml.kernel.org/r/20250908124740.2946005-1-chuhu@redhat.com
Link: https://lkml.kernel.org/r/20250908124740.2946005-2-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-fix-hugepages-cleanup-too-early
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -174,13 +174,13 @@ fi
 
 # set proper nr_hugepages
 if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
-	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+	orig_nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 	needpgs=$((needmem_KB / hpgsize_KB))
 	tries=2
 	while [ "$tries" -gt 0 ] && [ "$freepgs" -lt "$needpgs" ]; do
 		lackpgs=$((needpgs - freepgs))
 		echo 3 > /proc/sys/vm/drop_caches
-		if ! echo $((lackpgs + nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
+		if ! echo $((lackpgs + orig_nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
 			echo "Please run this test as root"
 			exit $ksft_skip
 		fi
@@ -191,6 +191,7 @@ if [ -n "$freepgs" ] && [ -n "$hpgsize_K
 		done < /proc/meminfo
 		tries=$((tries - 1))
 	done
+	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 	if [ "$freepgs" -lt "$needpgs" ]; then
 		printf "Not enough huge pages available (%d < %d)\n" \
 		       "$freepgs" "$needpgs"
@@ -536,6 +537,10 @@ CATEGORY="page_frag" run_test ./test_pag
 
 CATEGORY="rmap" run_test ./rmap
 
+if [ "${HAVE_HUGEPAGES}" = 1 ]; then
+	echo "$orig_nr_hugepgs" > /proc/sys/vm/nr_hugepages
+fi
+
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
 
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-fix-hugepages-cleanup-too-early.patch
selftests-mm-alloc-hugepages-in-va_high_addr_switch-test.patch
selftests-mm-fix-va_high_addr_switchsh-failure-on-x86_64.patch

