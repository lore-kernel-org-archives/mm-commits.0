Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83583BD243
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775236816; cv=none; b=WGd5c10LsFWqQbFvuD1PASiG3ectJdiSFkhyIlQiHfsGD3LrE65r3N22Aa3ZqsgG47hCtzoTFp/hETg2rJLtE0/2jz3kNIPP+6fqNfULdbyTBspQFQi8sHr0zcn0DbklvpXbFlV7pFNKrioDuJU6GIMkV+FXtN7x9gzAMk4qISc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775236816; c=relaxed/simple;
	bh=G5G/VIR4VBpobiSgzGj89AwaV47L15YUS5CYl/0pclU=;
	h=Date:To:From:Subject:Message-Id; b=ZI+bEnk1YOdGscAePpAlXI6DqWkUf0HYvL/PrbA06x8TRwPYOZxHvkk4n6ypza6SH+bNmXCvf4D5inBijCq3ymZV5KcZf0N8sTua2KpMpsLVzLRPt9ZO1yCsvffg60zvSGrdcvKbP9gOOvj2bljnwzJyYkMxMyl5e5kh+6S3QQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VMVO9gWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VMVO9gWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E1DC4CEF7;
	Fri,  3 Apr 2026 17:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775236816;
	bh=G5G/VIR4VBpobiSgzGj89AwaV47L15YUS5CYl/0pclU=;
	h=Date:To:From:Subject:From;
	b=VMVO9gWhcNFPXZeZD0DPTr7TaTNZDcS1j3BJSaSTSwOgDTjK2Fdikj7zkgZmzZiIx
	 sb3NPKpxkCqUxIJwj9bI/8iiyirtoVKV2B/2gbF61vZ5SOPJTJwEOX3rMJrqRb6OIk
	 4+CQRQ8kY6tbvtJDW3Pv9HkhaTGFOjJ/BcLng46A=
Date: Fri, 03 Apr 2026 10:20:15 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,leotimmins1974@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] liveupdate-initialize-incoming-flb-state-before-finish.patch removed from -mm tree
Message-Id: <20260403172016.33E1DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: initialize incoming FLB state before finish
has been removed from the -mm tree.  Its filename was
     liveupdate-initialize-incoming-flb-state-before-finish.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Leo Timmins <leotimmins1974@gmail.com>
Subject: liveupdate: initialize incoming FLB state before finish
Date: Wed, 25 Mar 2026 12:46:08 +0800

luo_flb_file_finish_one() decremented incoming.count before making sure
that the incoming FLB state had been materialized.  If no earlier incoming
retrieval had populated that state, the first decrement ran from zero and
skipped the last-user finish path.

Initialize the incoming FLB state before the first decrement so finish
uses the serialized refcount instead of an uninitialized value.

[akpm@linux-foundation.org: remove unneeded braces, per Pasha]
Link: https://lkml.kernel.org/r/20260325044608.8407-3-leotimmins1974@gmail.com
Fixes: cab056f2aae7 ("liveupdate: luo_flb: introduce File-Lifecycle-Bound global state")
Signed-off-by: Leo Timmins <leotimmins1974@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_flb.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/kernel/liveupdate/luo_flb.c~liveupdate-initialize-incoming-flb-state-before-finish
+++ a/kernel/liveupdate/luo_flb.c
@@ -192,8 +192,24 @@ static int luo_flb_retrieve_one(struct l
 static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = luo_flb_get_private(flb);
+	bool needs_retrieve = false;
 	u64 count;
 
+	scoped_guard(mutex, &private->incoming.lock) {
+		if (!private->incoming.count && !private->incoming.finished)
+			needs_retrieve = true;
+	}
+
+	if (needs_retrieve) {
+		int err = luo_flb_retrieve_one(flb);
+
+		if (err) {
+			pr_warn("Failed to retrieve FLB '%s' during finish: %pe\n",
+				flb->compatible, ERR_PTR(err));
+			return;
+		}
+	}
+
 	scoped_guard(mutex, &private->incoming.lock)
 		count = --private->incoming.count;
 
_

Patches currently in -mm which might be from leotimmins1974@gmail.com are

liveupdate-propagate-file-deserialization-failures.patch

