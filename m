Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03BC1A2544;
	Wed,  8 Jan 2025 08:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736324435; cv=none; b=IDn5aKXc4WnulwXNONMYTZXwIyrOaOy+V+xqCBlXB73UmjIRjZmB2Q0oazmglWCgSNk0a5MLVzM0LV7HAPCzfk3BbH03IoKdXT7EKio2FvD9t3eLFp/mAo5izcoOMjJZy09u4WIokk5oJkd1jq0UgMDqsQY6ZBVFx7RAW9fcVKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736324435; c=relaxed/simple;
	bh=t0rlTcxwkCQXCIG+vCg8JeAk85T7C4C5dBs9Ng6HwXQ=;
	h=Date:To:From:Subject:Message-Id; b=E2yA9aWPf2hvbaTz6OUTxuzopcSlDgrb2EB9KxzLs9VZRxKzihfAxQFqxh3lEbWpM8E2K82kifSm/ywg36f9bX2UvTQQqxts9h0uxADYhe9ui94xmi0PY1znYngBu4kAb+GmhPqwsJxnZobHGRdH+OdoHxdH4S9MQEUZQe7beBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m8XGhXjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m8XGhXjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366E7C4CEE1;
	Wed,  8 Jan 2025 08:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736324434;
	bh=t0rlTcxwkCQXCIG+vCg8JeAk85T7C4C5dBs9Ng6HwXQ=;
	h=Date:To:From:Subject:From;
	b=m8XGhXjNu7ta+3Qb9aO2gbl+5LdF7RxWkgE12YoECej6MwED/+SZR+FnE43T/dW0F
	 tN/HVa6/1qbGFh++LVsxoPnH9i0QibmoqimrbGPhNCcssJx2P+Se40a5ZoQdLbVi+9
	 B5asdm5o/nW/jo/tRTJEBl8EeY/C7FZgNCGqYgZ8=
Date: Wed, 08 Jan 2025 00:20:33 -0800
To: mm-commits@vger.kernel.org,vitalywool@gmail.com,syzkaller@googlegroups.com,stable@vger.kernel.org,samsun1006219@gmail.com,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baohua@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-zswap-disable-migration-while-using-per-cpu-acomp_ctx.patch removed from -mm tree
Message-Id: <20250108082034.366E7C4CEE1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: disable migration while using per-CPU acomp_ctx
has been removed from the -mm tree.  Its filename was
     mm-zswap-disable-migration-while-using-per-cpu-acomp_ctx.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: disable migration while using per-CPU acomp_ctx
Date: Tue, 7 Jan 2025 22:22:35 +0000

In zswap_compress() and zswap_decompress(), the per-CPU acomp_ctx of the
current CPU at the beginning of the operation is retrieved and used
throughout.  However, since neither preemption nor migration are disabled,
it is possible that the operation continues on a different CPU.

If the original CPU is hotunplugged while the acomp_ctx is still in use,
we run into a UAF bug as the resources attached to the acomp_ctx are freed
during hotunplug in zswap_cpu_comp_dead().

The problem was introduced in commit 1ec3b5fe6eec ("mm/zswap: move to use
crypto_acomp API for hardware acceleration") when the switch to the
crypto_acomp API was made.  Prior to that, the per-CPU crypto_comp was
retrieved using get_cpu_ptr() which disables preemption and makes sure the
CPU cannot go away from under us.  Preemption cannot be disabled with the
crypto_acomp API as a sleepable context is needed.

Commit 8ba2f844f050 ("mm/zswap: change per-cpu mutex and buffer to
per-acomp_ctx") increased the UAF surface area by making the per-CPU
buffers dynamic, adding yet another resource that can be freed from under
zswap compression/decompression by CPU hotunplug.

This cannot be fixed by holding cpus_read_lock(), as it is possible for
code already holding the lock to fall into reclaim and enter zswap
(causing a deadlock).  It also cannot be fixed by wrapping the usage of
acomp_ctx in an SRCU critical section and using synchronize_srcu() in
zswap_cpu_comp_dead(), because synchronize_srcu() is not allowed in
CPU-hotplug notifiers (see
Documentation/RCU/Design/Requirements/Requirements.rst).

This can be fixed by refcounting the acomp_ctx, but it involves complexity
in handling the race between the refcount dropping to zero in
zswap_[de]compress() and the refcount being re-initialized when the CPU is
onlined.

Keep things simple for now and just disable migration while using the
per-CPU acomp_ctx to block CPU hotunplug until the usage is over.

Link: https://lkml.kernel.org/r/20250107222236.2715883-2-yosryahmed@google.com
Fixes: 1ec3b5fe6eec ("mm/zswap: move to use crypto_acomp API for hardware acceleration")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Closes: https://lore.kernel.org/lkml/20241113213007.GB1564047@cmpxchg.org/
Reported-by: Sam Sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/lkml/CAEkJfYMtSdM5HceNsXUDf5haghD5+o2e7Qv4OcuruL4tPg6OaQ@mail.gmail.com/
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: syzbot <syzkaller@googlegroups.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-disable-migration-while-using-per-cpu-acomp_ctx
+++ a/mm/zswap.c
@@ -880,6 +880,18 @@ static int zswap_cpu_comp_dead(unsigned
 	return 0;
 }
 
+/* Remain on the CPU while using its acomp_ctx to stop it from going offline */
+static struct crypto_acomp_ctx *acomp_ctx_get_cpu(struct crypto_acomp_ctx __percpu *acomp_ctx)
+{
+	migrate_disable();
+	return raw_cpu_ptr(acomp_ctx);
+}
+
+static void acomp_ctx_put_cpu(void)
+{
+	migrate_enable();
+}
+
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 			   struct zswap_pool *pool)
 {
@@ -893,8 +905,7 @@ static bool zswap_compress(struct page *
 	gfp_t gfp;
 	u8 *dst;
 
-	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-
+	acomp_ctx = acomp_ctx_get_cpu(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 
 	dst = acomp_ctx->buffer;
@@ -950,6 +961,7 @@ unlock:
 		zswap_reject_alloc_fail++;
 
 	mutex_unlock(&acomp_ctx->mutex);
+	acomp_ctx_put_cpu();
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -960,7 +972,7 @@ static void zswap_decompress(struct zswa
 	struct crypto_acomp_ctx *acomp_ctx;
 	u8 *src;
 
-	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+	acomp_ctx = acomp_ctx_get_cpu(entry->pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 
 	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
@@ -990,6 +1002,7 @@ static void zswap_decompress(struct zswa
 
 	if (src != acomp_ctx->buffer)
 		zpool_unmap_handle(zpool, entry->handle);
+	acomp_ctx_put_cpu();
 }
 
 /*********************************
_

Patches currently in -mm which might be from yosryahmed@google.com are

revert-mm-zswap-fix-race-between-compression-and-cpu-hotunplug.patch

