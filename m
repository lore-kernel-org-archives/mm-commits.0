Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAD151C5A
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 00:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757724526; cv=none; b=EhMp2liPYkOh+1fLxE0dNn4T1r69mxHpaoBYmV+bD9L/mqEdYOics0tGpxSTkXRB4kdsWdccuBsPa10Yum0AMMLuPSBjaaXCqKtZUXqVoLbJ7fY8KhJ3yyQI1DsnGGMUy5Vpmm3VoeCnLUY1s9xVexfokCzP4WX4uR0MWGSRIJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757724526; c=relaxed/simple;
	bh=mPK3pcXOFeoxcAjdiCJi6fnmjkH0PW3rJFAIOeewt/M=;
	h=Date:To:From:Subject:Message-Id; b=ELfUCxuG5muGZMBRZxKePspCJd5xxvYGHhaMb68bzPvJEJ7ko7VAA87shCFVqW69E76Cx7cD61a4hgo66uesVvxmo523hXCjVRgznqPnY33jy65SaHmGFFYGtYI/yLeQtXB1nohtJP2PskG1X6DPx2evHzTkJ9VSAT/01wCX2Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lgKPzVSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lgKPzVSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46061C4CEF1;
	Sat, 13 Sep 2025 00:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757724526;
	bh=mPK3pcXOFeoxcAjdiCJi6fnmjkH0PW3rJFAIOeewt/M=;
	h=Date:To:From:Subject:From;
	b=lgKPzVSt7o1x+31MK02Ayf73h6XGzWE0pMAxH0dY/Ud2G45ve4KKeYi4dyPvuvm8F
	 YmmwWUiNRL1HWcCVAa73SvjiwAY2ci+4WmlnKoTuG2Uri37WKD8t3fNkDC676Wkc0q
	 7aIT/NkpQtvNEtSlz+tgPXSMrBHoPHw7I1sWN5T0=
Date: Fri, 12 Sep 2025 17:48:45 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-alloc-hugepages-in-va_high_addr_switch-test.patch added to mm-unstable branch
Message-Id: <20250913004846.46061C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: alloc hugepages in va_high_addr_switch test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-alloc-hugepages-in-va_high_addr_switch-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-alloc-hugepages-in-va_high_addr_switch-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Fri, 12 Sep 2025 09:37:10 +0800

Alloc hugepages in the test internally, so we don't fully rely on the
run_vmtests.sh.  If run_vmtests.sh does that great, free hugepages is
enough for being used to run the test, leave it as it is, otherwise setup
the hugepages in the test.

Save the original nr_hugepages value and restore it after test finish, so
leave a stable test envronment.

Link: https://lkml.kernel.org/r/20250912013711.3002969-3-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
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

