Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135D7217736
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188449; cv=none; b=iKnPpoXqEPZXN/EGl0a+qo6/Ikt5BbFK5XChFBKdEYD8kDIYULP6WpiWH3NIyxLzGwGu5wrU0Uam6DWev028SocoPtkwyRLiauxm9ec8etdL6sCJ3h33sJD38q+T42N8tPj6I/46hNKb90fTU24RanDT4T22VG53fTWouvMgN20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188449; c=relaxed/simple;
	bh=130V1dlbQsAy79/MFz7O+relPr6m/JPTpC1Nd64bCNk=;
	h=Date:To:From:Subject:Message-Id; b=kfgUGyKpwQwZQyB5ZnVyuROVbpLfgZtFykBeuo8B6nrFE2DMRDLguiVGey3mGnFo7TeyJhFygB4KMF9iResUCugnf13ReMfW1x+/4RbO2rhcIjlV6/pvutzUQ+D/mHQJolv5A1KhAwBIomBJexEP1JcJamUo1xcMe7o2mTh+JYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i1CFujAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i1CFujAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF45C4CEEC;
	Mon, 17 Mar 2025 05:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188448;
	bh=130V1dlbQsAy79/MFz7O+relPr6m/JPTpC1Nd64bCNk=;
	h=Date:To:From:Subject:From;
	b=i1CFujAdXkZtTtzpXGiX9F1xR7JBAU6HogXm4w1I+2PAlBccHfXUeiK5LE+F0Q2Wn
	 E33aOAeK0J/h9K6Ygxx0CZ0dc8bE3UHgneSCAyVk4Kn1krl1Qlyllk4/oeO+k3hzsf
	 yA1XHqtQ1Ya5pip4I5tILCVBiv3m0GVBbndyLWzo=
Date: Sun, 16 Mar 2025 22:14:08 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch removed from -mm tree
Message-Id: <20250317051408.DBF45C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip mlock tests if nobody user can't read it
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: skip mlock tests if nobody user can't read it
Date: Tue, 11 Mar 2025 13:18:22 +0000

If running from a directory that can't be read by unprivileged users,
executing on-fault-test via the nobody user will fail.

The kselftest build does give the file the correct permissions, but after
being installed it might be in a directory without global execute
permissions.

Since the script can't safely fix that, just skip if it happens.  Note
that the stderr of the `ls` command is unfiltered meaning the user sees a
"permission denied" error that can help inform them why the test was
skipped.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-11-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -353,7 +353,7 @@ echo "$nr_hugepgs" > /proc/sys/vm/nr_hug
 
 CATEGORY="compaction" run_test ./compaction_test
 
-if command -v sudo &> /dev/null;
+if command -v sudo &> /dev/null && sudo -u nobody ls ./on-fault-limit >/dev/null;
 then
 	CATEGORY="mlock" run_test sudo -u nobody ./on-fault-limit
 else
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

