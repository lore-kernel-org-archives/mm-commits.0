Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358BC2C08DF
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489970; cv=none; b=EhtdgfoKi1XYJp61oOvG5UEkta/TVOd6vSlnV/rwLWRgNf+Mpl5J8qLl9SgHRU+Tqrj2FR5rTm6nb4W+SdfNxln2cTZ0AzQpi0OnWttNH4a4opqyV/WToNEA5FKtnPXIufXYYSH/9xzVn7ZPtMegcFimLrObyTqi8MiNusnBD9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489970; c=relaxed/simple;
	bh=dBEPi+UdVZk2GX+NJFmzD2+kKuE05pNd2gzvdgSN1YA=;
	h=Date:To:From:Subject:Message-Id; b=tjxthYnmQCFgZChE2shCUvvxFkE8wIC37ipDYtNd8usPl0DOTIL58ZVj0rbE3ziVRdVjOVMHfy1YkfQ1TadwuZjVZmDJaA/RRPN/KWt0QmM7/Kq5E1L/1UKrYT6gEFp82s7S2/ktQQMdv7eiVGR31CBy77cet6ZV/zDB4IjCZlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZN3P2dAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZN3P2dAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0002EC4CEE7;
	Sun, 21 Sep 2025 21:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489970;
	bh=dBEPi+UdVZk2GX+NJFmzD2+kKuE05pNd2gzvdgSN1YA=;
	h=Date:To:From:Subject:From;
	b=ZN3P2dAdO76c9SYEE4goqkdS5TW6QWkHYUFsfEBUDjs89naOVrT3CihRDitITfzeN
	 BUpDgfiukV7G0SjyNP26CQ17VA7Q1iHL9C3iNmIjd/CeQUk+qw/O59t6M1/satESFa
	 v9lepqjZf3CrATLL0ICDkzikBUw+Wfx8ZfKnrXgU=
Date: Sun, 21 Sep 2025 14:26:09 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-alloc-hugepages-in-va_high_addr_switch-test.patch removed from -mm tree
Message-Id: <20250921212610.0002EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: alloc hugepages in va_high_addr_switch test
has been removed from the -mm tree.  Its filename was
     selftests-mm-alloc-hugepages-in-va_high_addr_switch-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


