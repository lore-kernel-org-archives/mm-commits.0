Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92D2EEBB
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 00:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766276254; cv=none; b=HRWTSh95LebDZLCefbg+Ghn1CjmP78MRd32XXGC3MYxZDNeR53Uassqyy74Ds+27qzagZ+zCRcaPG0IpXZZu+8nuYPcD93dyrdLUASbijGZre2OPK+w5LiOzehIQT4sTtlW/EptSCoyiLo+cw+WfWa7766CWMjA/t5SdQWQzvbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766276254; c=relaxed/simple;
	bh=I5LrZ9AFHP9Bg5Ip9o/qJlwTCUfEwv+J7JpkKMJmhLg=;
	h=Date:To:From:Subject:Message-Id; b=isSWphZmWWSwwWN9KNrPg0vZQ9Ih7wXFG+MsWSoytL6wmQAVANXame9z48qX7n5kVB4y/vSJALO6KEpCp2pkwoSlRjI/mTBGiLZR0USCqxhMT7vqBUqCg+ZUwG38J8bNbKKYPuX39magEz1AXC5E3v0Aj7dw1Qog5HoafuzQzrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KLAyHhLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KLAyHhLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAA9C4CEF5;
	Sun, 21 Dec 2025 00:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766276254;
	bh=I5LrZ9AFHP9Bg5Ip9o/qJlwTCUfEwv+J7JpkKMJmhLg=;
	h=Date:To:From:Subject:From;
	b=KLAyHhLStoyZ0kOd/kBv078NBCY6lzsQ4pVe9o/0RhfT2H8ecQagqWPM/e38/mVkj
	 18jE3J2AZS3hEyMFQIj6PAAdJWfNgr3fCJvmb9LPz4dbrcLOncfwUOZcarlUUc0J/8
	 JK/2FN5kpwF3OhxfxG7yhwN4S3x5mh243CucwlGo=
Date: Sat, 20 Dec 2025 16:17:33 -0800
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,pedrodemargomes@gmail.com,david@kernel.org,chengming.zhou@linux.dev,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-pte_unmap_unlock-of-wrong-address-in-break_ksm_pmd_entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20251221001734.2AAA9C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: fix pte_unmap_unlock of wrong address in break_ksm_pmd_entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-ksm-fix-pte_unmap_unlock-of-wrong-address-in-break_ksm_pmd_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-pte_unmap_unlock-of-wrong-address-in-break_ksm_pmd_entry.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sasha Levin <sashal@kernel.org>
Subject: mm/ksm: fix pte_unmap_unlock of wrong address in break_ksm_pmd_entry
Date: Sat, 20 Dec 2025 15:29:26 -0500

On ARM32 with HIGHMEM/HIGHPTE, break_ksm_pmd_entry() triggers a BUG during
KSM unmerging because pte_unmap_unlock() is passed a pointer that may be
beyond the mapped PTE page.

The issue occurs when the PTE iteration loop completes without finding a
KSM page.  After the loop, 'ptep' has been incremented past the last PTE
entry.  On ARM32 LPAE with 512 PTEs per page (512 * 8 = 4096 bytes), this
means ptep points to the next page, outside the kmap'd region.

When pte_unmap_unlock(ptep, ptl) calls kunmap_local(ptep), it unmaps the
wrong page address, leaving the original kmap slot still mapped.  The next
kmap_local then finds this slot unexpectedly occupied:

  WARNING: mm/highmem.c:622 kunmap_local_indexed  (address mismatch)
  kernel BUG at mm/highmem.c:564  __kmap_local_pfn_prot  (slot not empty)

Fix this by passing start_ptep to pte_unmap_unlock(), which always points
within the originally mapped PTE page.

Reproducer: Run LTP ksm03 test on ARM32 with HIGHMEM enabled.  The test
triggers KSM merging followed by unmerging (writing 0 then 2 to
/sys/kernel/mm/ksm/run), which exercises break_ksm_pmd_entry().

Link: https://lkml.kernel.org/r/20251220202926.318366-1-sashal@kernel.org
Fixes: 5d4939fc2258 ("ksm: perform a range-walk in break_ksm")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Assisted-by: claude-opus-4-5-20251101
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksm-fix-pte_unmap_unlock-of-wrong-address-in-break_ksm_pmd_entry
+++ a/mm/ksm.c
@@ -650,7 +650,7 @@ static int break_ksm_pmd_entry(pmd_t *pm
 		}
 	}
 out_unlock:
-	pte_unmap_unlock(ptep, ptl);
+	pte_unmap_unlock(start_ptep, ptl);
 	return found;
 }
 
_

Patches currently in -mm which might be from sashal@kernel.org are

mm-ksm-fix-pte_unmap_unlock-of-wrong-address-in-break_ksm_pmd_entry.patch

