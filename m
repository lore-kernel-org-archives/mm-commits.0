Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC9615491
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 17:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709660425; cv=none; b=i3Dyv3EcBdUWNmwxaUiqiOZKXYLeT8TPoplL3i672b+H8FTZIIb6IRohBm0QX7a9pm7U1Wog9oPhThhwbwYuRD0jcPfdh3BlE2BLt7jwOYQVegY7w+/9KFBwm2JKZMczL0XQ7s3zlfVGhdkVvk0I4XqSYZTI3gmSOm53zn4R93A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709660425; c=relaxed/simple;
	bh=6DVhbb5xvOJiRtiVp6DXpaQIBCf1KkWRt0s3DvArTZY=;
	h=Date:To:From:Subject:Message-Id; b=nlDfisoPuvCL4mTxK8NrFVM6DqfoMJJ4QuoCeQt8VnENJ07YyDzQX4u0HPs5e3edP6Yx1rwawz8hTttn39dkmEoB+B86XFCyvE1BcAll/iLpiIc+4eXCQC10EdTPv7wTi5AUMD9hWaAWfg6EstlQwlU24RvWb44bL4ZLDHsU3pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=loO2CEm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="loO2CEm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3887C433F1;
	Tue,  5 Mar 2024 17:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709660425;
	bh=6DVhbb5xvOJiRtiVp6DXpaQIBCf1KkWRt0s3DvArTZY=;
	h=Date:To:From:Subject:From;
	b=loO2CEm2v83B5FOCtBKp1S9bSqh4Y1T6SFGvbot+YL5Bx+63TG9ZVIdJzgxaBUcGk
	 Mxqd9zt6fAR+/oXGiLSrqCRK7nVBmNH4hdHEkvUzo9EZ+mWL8sHX/5N+0chIXlSULO
	 uPnJI8Yk70W7RusTEBCO4yo/ApfzR0iVfLwRfhqg=
Date: Tue, 05 Mar 2024 09:40:24 -0800
To: mm-commits@vger.kernel.org,imbrenda@linux.ibm.com,frankja@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-supplement-for-ptdesc-conversion-v2.patch added to mm-unstable branch
Message-Id: <20240305174024.E3887C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390-supplement-for-ptdesc-conversion-v2
has been added to the -mm mm-unstable branch.  Its filename is
     s390-supplement-for-ptdesc-conversion-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-supplement-for-ptdesc-conversion-v2.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: s390-supplement-for-ptdesc-conversion-v2
Date: Tue, 5 Mar 2024 15:21:54 +0800

fix build failure

Link: https://lkml.kernel.org/r/20240305072154.26168-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/gmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/gmap.c~s390-supplement-for-ptdesc-conversion-v2
+++ a/arch/s390/mm/gmap.c
@@ -206,10 +206,10 @@ static void gmap_free(struct gmap *gmap)
 
 	/* Free additional data for a shadow gmap */
 	if (gmap_is_shadow(gmap)) {
-		struct ptdesc *ptdesc;
+		struct ptdesc *ptdesc, *n;
 
 		/* Free all page tables. */
-		list_for_each_entry_safe(ptdesc, next, &gmap->pt_list, pt_list)
+		list_for_each_entry_safe(ptdesc, n, &gmap->pt_list, pt_list)
 			page_table_free_pgste(ptdesc);
 		gmap_rmap_radix_tree_free(&gmap->host_to_rmap);
 		/* Release reference to the parent */
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-correct-the-wrong-comment-about-ptdesc-__page_flags.patch
mm-pgtable-add-missing-pt_index-to-struct-ptdesc.patch
s390-supplement-for-ptdesc-conversion.patch
s390-supplement-for-ptdesc-conversion-v2.patch

