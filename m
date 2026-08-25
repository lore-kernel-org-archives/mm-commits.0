Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C418346AE1
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622857; cv=none; b=eccDRFMUfWzezP0bcemK14xZSc4n1T5hdpHYa1uYC2R7mCN9EUStwMDPLRq9q/Lav0xiek/NWD/elSRvGiZTIwEDX5AqeTlQ3c3gqlMFJkAM6SV5YyVoop8ZxnfI81TuVqKeHgqdV7T5ny5IVgB2s4slug+kSol1uZWRSG9CP5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622857; c=relaxed/simple;
	bh=t1XbKpi0Y7u2zw7KR9TdVM1ckcA3AHyz6ywzmITbeAE=;
	h=Date:To:From:Subject:Message-Id; b=c2Kp3yxaxL/BLOmt833JhjBygkScybpyylDtzjt5Me1Fz1+jzEaKxmsHW4qNH9Yz/KXs4LPeJrTmGi2Un/EpjrtllTKIEgxvemla/yLlhmvEG/3SydzGVfbUBIGviCfP0NPWg8vPopdVgImhe3b3JvZUiYANv9m+4nOQOEJlUpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I75OnGVn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I75OnGVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB2D1F000E9;
	Tue, 25 Aug 2026 01:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622856;
	bh=JCXQzCpwRhrA6eDmoYmYodWLv5sCot9OLk+Rtl+z1uQ=;
	h=Date:To:From:Subject;
	b=I75OnGVnPS3Kc4FdZ55rdHCZJL0I7/Iw/uyknTGesscA1cuC+2chDxYS88AJeD071
	 bBrrebKgs4L+UGbNXrCXILf9qjTHFE+eH2RX38NlTh818mZ6y248322jjUb2fsMXUe
	 OflcLamh2yPL0MqkAUZHAzO0dplf588P3zQ6fVmk=
Date: Mon, 24 Aug 2026 18:54:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,anshuman.khandual@arm.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch removed from -mm tree
Message-Id: <20260825015416.0AB2D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: drop duplicate test_seal_mprotect_two_vma_with_gap() call
has been removed from the -mm tree.  Its filename was
     selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: drop duplicate test_seal_mprotect_two_vma_with_gap() call
Date: Thu, 6 Aug 2026 11:08:50 +0800

mseal_test main() invokes test_seal_mprotect_two_vma_with_gap() twice. 
The second run repeats all assertions with no benefit.  Drop the duplicate
call.

Link: https://lore.kernel.org/20260806030850.76077-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -1876,7 +1876,7 @@ int main(void)
 	if (!pkey_supported())
 		ksft_print_msg("PKEY not supported\n");
 
-	ksft_set_plan(88);
+	ksft_set_plan(87);
 
 	test_seal_addseal();
 	test_seal_unmapped_start();
@@ -1914,7 +1914,6 @@ int main(void)
 	test_seal_mprotect_partial_mprotect(true);
 
 	test_seal_mprotect_two_vma_with_gap();
-	test_seal_mprotect_two_vma_with_gap();
 
 	test_seal_mprotect_merge(false);
 	test_seal_mprotect_merge(true);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

