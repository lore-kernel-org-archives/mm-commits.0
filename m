Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB38367296
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 02:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638059; cv=none; b=VR94HP/a7nwHjRQDR/TMg625HkpTC5ahMlvSD7Imney5UpC635QJu9X+SHM/LiojbOJPQ6Rt/f35Ii31sUBnxKOKA8KTT80jkEJ+ThyccrSZ7ET1uawcUKnI4BHT17Nn+XFNnLf1D/CAw21rnkxNq8uAHa9eFGf6ydBpFfdeBPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638059; c=relaxed/simple;
	bh=XeXlydUmc056W7n2yvERQvPxwNPHiOCV2vllaR0NG8g=;
	h=Date:To:From:Subject:Message-Id; b=eIxRiN4TMhGqPwjM9+oSJ3Mf/vLkOagCsqXcUJFsaSXU6gG7JFFZxAp/iFgRn2yXN6rgMrPW5is6IJxfO9BrC0PGNF7IDI+ezd9rC6b451N8/vTcLd54N4a1r4Cz40r0C5qiMHPabJbMaaJFoaI6jKT8rLTRCp2wXp0QUP2WNNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sBt1gF59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sBt1gF59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32629C2BCB0;
	Wed, 13 May 2026 02:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778638059;
	bh=XeXlydUmc056W7n2yvERQvPxwNPHiOCV2vllaR0NG8g=;
	h=Date:To:From:Subject:From;
	b=sBt1gF59rCGE1Cb5ljyI0baWf+ohBR7j/xQN8Ua3/g5TJpcSOBSIkgcCy4Ts7gBTw
	 yWVPfVATGICYY7+IS3W9yTJmpXqksnR8OlACsu/4jOyB5Eer7Bc3CX52MgmbyR/58c
	 tzV64r+0Lj2eY54efddPebtTXi4Ng8G2XxBV0IMs=
Date: Tue, 12 May 2026 19:07:38 -0700
To: mm-commits@vger.kernel.org,qiwu.chen@transsion.com,qiwuchen55@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix.patch removed from -mm tree
Message-Id: <20260513020739.32629C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: chenqiwu <qiwuchen55@gmail.com>
Subject: mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix
Date: Sun, 10 May 2026 08:36:34 +0800

build fix

Link: https://lore.kernel.org/20260510003634.GB5833@rlk
Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/vmscan.h~mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix
+++ a/include/trace/events/vmscan.h
@@ -398,7 +398,7 @@ TRACE_EVENT(mm_vmscan_write_folio,
 	TP_ARGS(folio),
 
 	TP_STRUCT__entry(
-		__field(unsigned long, folio)
+		__field(struct folio *, folio)
 		__field(int, lru)
 	),
 
_

Patches currently in -mm which might be from qiwuchen55@gmail.com are


