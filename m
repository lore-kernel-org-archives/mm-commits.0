Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329357;
	b=UXfpWJTY+ubUyvx7AsG/NMpMJOqFhFQTq7oRSWfwe+TnahtRaKxf33C/LKNcNwQw/UcA
	 m1JznF2ShXq4/X7/h59cOdmtIve817Xordker0HjroIiZsVCceNsBrWc1X3b2o/TRxmIe
	 9GPRgLFt/5PPxj9+AKFrLah+j2yFnBfLF++/0jHUWjD8E4S3chdYsy22FWBKy/RS6g8kf
	 KjAdngBSaVjSA29zhR6IX9bKml+fIglSrrkE21w+FbXHgQeKdz8ni+EL4H2VtdHzVPNmQ
	 E+Fer9wxQHGf40sMxGVGfnIbp0Pt7ZhGEh7EnLpzJRCL/+qX59N4Q3fg+VRXeCpTCqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329357;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/xoooYHKS9tTW5jNVNkKCIse1nuB6WPBkUfzp3ldH5Q=;
	b=Usc84bi065Q+9Ya0tLNv7+U7U+sYVAW8b6UAIx3ROPigWDmBLCziDsnC7mGgiEREMnJ+
	 nSVaOR/2Q0uFTWwz9vq+z0Dkw/c3Rek+FDUxJCPTYorI8/sUQvLkSVd8ivZOupTB0b7Gr
	 nqRiclzYr5OmtLhGnp9Nuckd2egKxr6q8410oD6+bIMN5Bzybx6K6U7w0csPmgxuT1ThU
	 imOJ8stYrMTwGpVU+C+7nkiK8gqubXBtiUs1AB+eitqkkbKZhXrNLymOTPDif8/07240h
	 uLBFmOibhtJw/mznggf2ATcCSOZROG9uWb4mt9W3FzwRTUFo2ZmCMOlrkh2PLkTnBkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RWrlT1qi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D303606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RWrlT1qi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B0F1F000C1;
	Fri, 30 Oct 2026 03:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793329357;
	bh=/xoooYHKS9tTW5jNVNkKCIse1nuB6WPBkUfzp3ldH5Q=;
	h=Date:To:From:Subject;
	b=RWrlT1qiWcL9RsGqtomluT7uY1UvXTWD+mhQSdbuTDrI64fOs4lKySu+S2+wPFTBX
	 kv9JdHynp1UBHR6FzY0q0kfPDUNZPY/rU9kI5VbG26vWIILwM8PhWcD1V9ZluWlPdU
	 8jtHF0QVcUw+XagSayzWkHYr82RrKX1NtJVnZmHc=
Date: Thu, 29 Oct 2026 20:02:36 -0700
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,zhangbo0325@gmail.com,
	richardycc@google.com,minchan@kernel.org,hdanton@sina.com,bgeffon@google.com,
	baohua@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch added to mm-nonmm-unstable branch
Message-Id: <20261030030237.28B0F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: zstd: do not use kvzalloc() for zstd allocations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: zstd: do not use kvzalloc() for zstd allocations
Date: Sun, 25 Oct 2026 11:18:26 +0900

When a dictionary is configured, zstd allocates all of its memory (C/D
dictionaries, compression and decompression contexts and compression
workspaces) via zstd_custom_alloc().  zstd_custom_alloc() uses
kvzalloc(), which falls back to vmalloc() only when kmalloc() fails,
and kmalloc() rounds such sizes up to a power-of-two number of pages.

For example, on x86_64 with a 110K dictionary, switching from
kvzalloc() to __vmalloc() reduces allocations from:
- CDict (level 3):            512 KB -> 400 KB
- CDict (levels 12+):        2048 KB -> 1552 KB
- DCtx (per-CPU):             128 KB -> 96 KB
- CCtx workspace (level 3):   128 KB -> 84 KB (per-CPU)
- CCtx workspace (level 14+): 1024 KB -> 764 KB (per-CPU)

Use __vmalloc() for allocations larger than PAGE_SIZE (and kzalloc()
for smaller ones), which is also how zram allocates zstd workspaces
when no dictionary is configured.  zstd_custom_free() already uses
kvfree(), which handles both.

Link: https://lore.kernel.org/20261025021839.1542805-11-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hillf Danton <hdanton@sina.com>
---

 drivers/block/zram/backend_zstd.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/backend_zstd.c~zram-zstd-do-not-use-kvzalloc-for-zstd-allocations
+++ a/drivers/block/zram/backend_zstd.c
@@ -26,10 +26,17 @@ struct zstd_params {
 /*
  * For C/D dictionaries we need to provide zstd with zstd_custom_mem,
  * which zstd uses internally to allocate/free memory when needed.
+ *
+ * zstd allocations (C/D dictionaries and contexts) are large and
+ * long-lived.  Don't use kvzalloc() for them: when enough physically
+ * contiguous memory is available it serves them from kmalloc(), which
+ * rounds them up to a power-of-two number of pages.
  */
 static void *zstd_custom_alloc(void *opaque, size_t size)
 {
-	return kvzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	if (size <= PAGE_SIZE)
+		return kzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	return __vmalloc(size, GFP_NOIO | __GFP_NOWARN | __GFP_ZERO);
 }
 
 static void zstd_custom_free(void *opaque, void *address)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-prefix-backends-printk-s.patch
zram-remove-debugfs-entry-on-init-failure.patch
zram-reset-writeback-state-in-zram_reset_device.patch
zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch
zram-remove-stale-warn_on-from-zram_read_page.patch
zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch
zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch
zram-lz4-use-lz4_decompress_safe_usingdict.patch
zram-lz4hc-use-lz4_decompress_safe_usingdict.patch
zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch
zram-split-zcomp-into-separate-r-w-streams.patch
zram-introduce-shared-decompression-streams.patch
zram-allocate-bounce-buffer-for-spanning-objects.patch
zram-borrow-idle-decompression-streams-in-exclusive-mode.patch
zram-use-a-singleton-compression-context-for-recompression.patch

