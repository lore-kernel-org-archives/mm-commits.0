Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EC54CB5D
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OXXqbNUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CA1C433C7;
	Wed, 20 Dec 2023 22:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112551;
	bh=IcLzVADZzN0yR6ykuYxPL1ZDUJOOQOWUSgUgGrU220A=;
	h=Date:To:From:Subject:From;
	b=OXXqbNUYGAolQREwTSLDEWt/ROgKwXsdCaz8D2oUW1bpqJK7OXL47pdUCPOHIw64D
	 N+9E+YgnPEzoTSt0T67dr9F3+LvQwyOmB3z1cirh5UxhPANHWpRIoMjlf0SPwYq3wG
	 EEbO3HTeKgfRX7pAhXo2XWTkeJN7e4I3sMmcj6nk=
Date: Wed, 20 Dec 2023 14:49:10 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,vbabka@suse.cz,shy828301@gmail.com,rientjes@google.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,itaru.kitayama@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,catalin.marinas@arm.com,apopple@nvidia.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-kugepaged-restore-thp-settings-at-exit.patch removed from -mm tree
Message-Id: <20231220224911.31CA1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/kugepaged: restore thp settings at exit
has been removed from the -mm tree.  Its filename was
     selftests-mm-kugepaged-restore-thp-settings-at-exit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm/kugepaged: restore thp settings at exit
Date: Thu, 7 Dec 2023 16:12:06 +0000

Previously, the saved thp settings would be restored upon a signal or at
the natural end of the test suite.  But there are some tests that directly
call exit() upon failure.  In this case, the thp settings were not being
restored, which could then influence other tests.

Fix this by installing an atexit() handler to do the actual restore.  The
signal handler can now just call exit() and the atexit handler is invoked.

Link: https://lkml.kernel.org/r/20231207161211.2374093-6-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-kugepaged-restore-thp-settings-at-exit
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -374,18 +374,22 @@ static void pop_settings(void)
 	write_settings(current_settings());
 }
 
-static void restore_settings(int sig)
+static void restore_settings_atexit(void)
 {
 	if (skip_settings_restore)
-		goto out;
+		return;
 
 	printf("Restore THP and khugepaged settings...");
 	write_settings(&saved_settings);
 	success("OK");
-	if (sig)
-		exit(EXIT_FAILURE);
-out:
-	exit(exit_status);
+
+	skip_settings_restore = true;
+}
+
+static void restore_settings(int sig)
+{
+	/* exit() will invoke the restore_settings_atexit handler. */
+	exit(sig ? EXIT_FAILURE : exit_status);
 }
 
 static void save_settings(void)
@@ -415,6 +419,7 @@ static void save_settings(void)
 
 	success("OK");
 
+	atexit(restore_settings_atexit);
 	signal(SIGTERM, restore_settings);
 	signal(SIGINT, restore_settings);
 	signal(SIGHUP, restore_settings);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

