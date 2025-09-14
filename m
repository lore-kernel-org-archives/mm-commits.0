Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8521833987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810123; cv=none; b=Ud7sq8x4VkfXC6XW5YtGWUV9jpVousMiEkDoGqqOV89C5xysDqSi4WrdnvJ6qTPrzhp8+yn0n070tl04PTHhGr3KDORXinfWgoaJq74YoKPBA52k7l2RynmSRhrQwWEMOJn0be+vAmqOt0kZntVQ9iZuJkfvHzGrLiOGYbP3zSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810123; c=relaxed/simple;
	bh=CR7BW70uFg1yaAUpz8/5VlFZbib/NzWWK2FxB5WrIGM=;
	h=Date:To:From:Subject:Message-Id; b=Xi4PDwTiM2xsiKLv5zZcF3KHgr1lzZnvPe8EYjj5it3oRw/vY9vDer82TsrG8cNTpIp6PzZJNzFtxgctbtyky3FELNSCYjxPqCCRSGbqMsIqsVL08dvTKciMFd3sR7pvWwhKmlSMtFQD1R6c4auMpshvmk6ho8QC3GqxKofa9KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u1vW3fbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u1vW3fbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A03CC4CEEB;
	Sun, 14 Sep 2025 00:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810123;
	bh=CR7BW70uFg1yaAUpz8/5VlFZbib/NzWWK2FxB5WrIGM=;
	h=Date:To:From:Subject:From;
	b=u1vW3fboJU4hwGl1CLrm978orvxEULu7Khmc7Bxqc9NmsPU3pL7rnZEASSGNjsjuc
	 UxjsTTvjqx5oik4dq/dQAmlyaCKpkewnBJxfkmllcSNzOFHXXBoCw3HfIHQnyc39ev
	 z6p5wPbR05OlakeJ9VFL6k6xXr8pXfiBkhV92Ors=
Date: Sat, 13 Sep 2025 17:35:22 -0700
To: mm-commits@vger.kernel.org,nicolas.frattaroli@collabora.com,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] listh-add-missing-kernel-doc-for-basic-macros.patch removed from -mm tree
Message-Id: <20250914003523.5A03CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: list.h: add missing kernel-doc for basic macros
has been removed from the -mm tree.  Its filename was
     listh-add-missing-kernel-doc-for-basic-macros.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: list.h: add missing kernel-doc for basic macros
Date: Tue, 19 Aug 2025 00:55:07 -0700

kernel-doc for the basic LIST_HEAD() and LIST_HEAD_INIT() macros has been
missing forever (i.e., since git).  Add them for completeness.

Link: https://lkml.kernel.org/r/20250819075507.113639-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/list.h~listh-add-missing-kernel-doc-for-basic-macros
+++ a/include/linux/list.h
@@ -20,8 +20,16 @@
  * using the generic single-entry routines.
  */
 
+/**
+ * LIST_HEAD_INIT - initialize a &struct list_head's links to point to itself
+ * @name: name of the list_head
+ */
 #define LIST_HEAD_INIT(name) { &(name), &(name) }
 
+/**
+ * LIST_HEAD - definition of a &struct list_head with initialization values
+ * @name: name of the list_head
+ */
 #define LIST_HEAD(name) \
 	struct list_head name = LIST_HEAD_INIT(name)
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are


