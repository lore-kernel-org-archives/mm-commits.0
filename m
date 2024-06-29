Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68668AD55
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628237; cv=none; b=kC5LpYNiL2kFYhYBQuo8qsJnz0Wt1GiBxt/HYgpkpWHKXIBClA18MGQvNHBkqnvRLG7EUF0d5dmc9rNVAsYE4xHBCRL9yCZhG5o2R0vhHulOrcsKYLL8w+Nx0p9uO54kFMGdHkPxqTgGM5yZlbODzP3T99upZ0M0iuoDvQRS7F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628237; c=relaxed/simple;
	bh=46THAMOoqX8+S4X//naIp1sE5wXcT5w+65HGwbGEZ6M=;
	h=Date:To:From:Subject:Message-Id; b=luVl+M+1UQRQHhdysKdci4kTRoDzmmQvvcWOXtZMqgNy/gs+0HRz2BNtIHg1bXFT/IIiZEVGwGoD5PbBv7QOmCrqzkjecxQWw8gOGKrq817yRWIJIsHVsxsVJheX9gnZK2zy9ywjd5nxpxXl02A73l6ZkUo7CfgnYdfWHr2Q1r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AZiLEGf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AZiLEGf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBDDC116B1;
	Sat, 29 Jun 2024 02:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628237;
	bh=46THAMOoqX8+S4X//naIp1sE5wXcT5w+65HGwbGEZ6M=;
	h=Date:To:From:Subject:From;
	b=AZiLEGf1mn6F8TMQOzEsH5HmH5DH+JKLjWXwVP/ShJc9ggMudt/xlc0ufHlYbbrFb
	 mPNvfzkvH8XY1uRiQTGdawPFtMjfHnvPEKSBsb1DmmjvjYOmUzdXpsyikmUMnXy/tF
	 hH3HVnTnN6L97l+tt820ybDmyUAXpAs1gAxhg8oA=
Date: Fri, 28 Jun 2024 19:30:36 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-disable-kmsan-when-deferred_struct_page_init-is-enabled.patch removed from -mm tree
Message-Id: <20240629023037.3EBDDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: disable KMSAN when DEFERRED_STRUCT_PAGE_INIT is enabled
has been removed from the -mm tree.  Its filename was
     kmsan-disable-kmsan-when-deferred_struct_page_init-is-enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: disable KMSAN when DEFERRED_STRUCT_PAGE_INIT is enabled
Date: Fri, 21 Jun 2024 13:34:47 +0200

KMSAN relies on memblock returning all available pages to it (see
kmsan_memblock_free_pages()).  It partitions these pages into 3
categories: pages available to the buddy allocator, shadow pages and
origin pages.  This partitioning is static.

If new pages appear after kmsan_init_runtime(), it is considered an error.
DEFERRED_STRUCT_PAGE_INIT causes this, so mark it as incompatible with
KMSAN.

Link: https://lkml.kernel.org/r/20240621113706.315500-4-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~kmsan-disable-kmsan-when-deferred_struct_page_init-is-enabled
+++ a/mm/Kconfig
@@ -952,6 +952,7 @@ config DEFERRED_STRUCT_PAGE_INIT
 	depends on SPARSEMEM
 	depends on !NEED_PER_CPU_KM
 	depends on 64BIT
+	depends on !KMSAN
 	select PADATA
 	help
 	  Ordinarily all struct pages are initialised during early boot in a
_

Patches currently in -mm which might be from iii@linux.ibm.com are


