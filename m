Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC11C13175F
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 15:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709739857; cv=none; b=Gn7QxxjxXh5ltARW8EfnfZNmRg7SSHP5clK2IxHsgRz9c/NBPXk0aKTGOx6bxK43iFq6IU117v8kGX45jWJaQH5891R8UtbMgt4S1e8RD9nGucYAP/jFRv/84eb1EDA7QFPCY8caY//9JbcI8JZ3ZT8SUW2jX/JZzKSxNhWsYdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709739857; c=relaxed/simple;
	bh=+CIdYxbtM2eqt3Qw4JinzgwyxooraYU3EdrWrvIgN2s=;
	h=Date:To:From:Subject:Message-Id; b=ZU5fRTXR6RCEX0XCmAzXptqO6EU2avSU/s/Of5XG12LIQ41aMAJ94StDg0erRXVFH6j7ilLaugYljaN63kTaz7VKeyOU6IQX2R88jJDYJhAV7SASdDZUi7JjKmfld6PRsH33gfk/ggvZS6BHy++MhTKkTMqz8J0hMyO9QIFkkgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kZzigdAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kZzigdAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ED6C433C7;
	Wed,  6 Mar 2024 15:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709739856;
	bh=+CIdYxbtM2eqt3Qw4JinzgwyxooraYU3EdrWrvIgN2s=;
	h=Date:To:From:Subject:From;
	b=kZzigdALWKToJLNjgvrEpmsc5suwmLBpIV+IexQmkJM+bQYTxsJ6zP8dy5lSZDzBh
	 k48RTYYNrNtkyAoXksr2wntv98sCDq0clFBW+8B7RIBNR7bj9HioRCPnXxux5RiRKu
	 HS6f19FP/rijyS24inMB2/ELlDFwH6f7vuJXfGO0=
Date: Wed, 06 Mar 2024 07:44:15 -0800
To: mm-commits@vger.kernel.org,imbrenda@linux.ibm.com,frankja@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] s390-supplement-for-ptdesc-conversion-v2.patch removed from -mm tree
Message-Id: <20240306154416.56ED6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390-supplement-for-ptdesc-conversion-v2
has been removed from the -mm tree.  Its filename was
     s390-supplement-for-ptdesc-conversion-v2.patch

This patch was dropped because it was folded into s390-supplement-for-ptdesc-conversion.patch

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

