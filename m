Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E2913E02A
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 03:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786418297; cv=none; b=fXAgSkfrPT73GxxCIzLvQTL+15Kee3CAJ5XTehFDbwhcnnOrV/xbbu3WaCwo3TIvHqkuveemjIj40OEO53gE6ZvkNkt3NP+zVkppD993XF0AW8fk6DKgCvS56VlyGLTyKwWADR54Mgep34dI/2+3DOUgslp3hWPwBSnEFEwuZv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786418297; c=relaxed/simple;
	bh=Ypmb2Uts3Km+RDyi6RD9peLV7ZXej40rc4KizqVAaWQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=onTxoQIQc4Cklj+w+za2UyB78mf6ruyOX1R+c5Z3vesgkuijjVrVNu/QVVaggsJNw0mbugK1zu/gPwosGyNIqJzny7LkzzZch7oXVH+EDb0pZGY8pjis2AHQZ1I2fEQv0kqz71PerkTS1+EdknY8ZQ9pWoA/z/Esute0Gt6waHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZWNJ+myK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZWNJ+myK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F2E1F000E9;
	Tue, 11 Aug 2026 03:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786418295;
	bh=a93hr+aS3rOR3+WoE/Adzms3sYfp9JoJ2+3iimA5d0I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZWNJ+myKn0TYAUfyw2gXen3pOlstBwjfQgugPJVEXdOVTTnhFtO1DO4faxMdJWdt7
	 DDe2wRH+AJapU9gOJuZ4TMIMJo8QpyZxbA+0RgyGI6h4OaxhTvjlDSHkwAn6CZ2cDT
	 TwuCK8KQDDZruCbx1CDaLW8z1cXB/KHX1Jd9K1R8=
Date: Mon, 10 Aug 2026 20:18:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox
 <willy@infradead.org>, mm-commits@vger.kernel.org,
 kent.overstreet@linux.dev, bigeasy@linutronix.de, arnd@arndb.de
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-Id: <20260810201814.52d1353d5c3f1ce27ba10186@linux-foundation.org>
In-Reply-To: <akzZSIN5ALd8iH52@gmail.com>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
	<ako1sMPVu4dfQR4K@casper.infradead.org>
	<akuFSv7JaXo6M8gx@gmail.com>
	<akuT8pEjBKvByPlA@arm.com>
	<akuzsny_3EpxaPww@gmail.com>
	<akvW9RwjVmRnNzHM@arm.com>
	<akw4FspAoT60tQeu@arm.com>
	<akzZSIN5ALd8iH52@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 7 Jul 2026 04:26:43 -0700 Breno Leitao <leitao@debian.org> wrote:

> > Anyway, a better diff for the first idea below. I need to do more
> > testing and can turn it into a proper commit (if we don't deem it
> > redundant because of the other min_unref_count).
> 
> Thanks for it. I've reviewed it and it looks sane.
> 
> I am also testing it on my side.

This went quiet.  I take it that we won't be proceeding with this
patch, "radix-tree: fix kmemleak false positives on tree head
reassignment", v2?


From: Breno Leitao <leitao@debian.org>
Subject: radix-tree: fix kmemleak false positives on tree head reassignment
Date: Fri, 03 Jul 2026 08:22:03 -0700

Kmemleak periodically reports transient false positives for radix tree
nodes allocated through the IDR, for example:

  unreferenced object 0xffff0004d6ac4200 (size 576):
    comm "tcpeventd", pid 6412
    backtrace (crc 335d668a):
      kmem_cache_alloc_noprof
      radix_tree_node_alloc
      radix_tree_extend
      idr_get_free
      idr_alloc_cyclic
      map_create
      __sys_bpf

radix_tree_extend() (grow) and radix_tree_shrink() (shrink) repoint
root->xa_head to a new node.  If a kmemleak scan has already walked past
root->xa_head, the new head is not reachable from any scanned pointer
until the following scan, so kmemleak reports it as leaked even though it
is live.

This is the same race fixed for the XArray API in commit a1a029bcea59
("XArray: fix kmemleak false positive in xas_shrink()").  The IDR uses the
radix tree API directly and hits it on both the grow and the shrink path,
so mark the new head as a transient leak in both.

Add a matching kmemleak_transient_leak() stub to the radix tree test
harness so the userspace lib/radix-tree.c build keeps building.

Link: https://lore.kernel.org/20260703-radix-tree-v2-1-38bb6efb5f6e@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                      |    7 ++++++-
 tools/testing/shared/linux/kmemleak.h |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/lib/radix-tree.c~radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment
+++ a/lib/radix-tree.c
@@ -455,6 +455,8 @@ static int radix_tree_extend(struct radi
 		node->slots[0] = (void __rcu *)entry;
 		entry = node_to_entry(node);
 		rcu_assign_pointer(root->xa_head, entry);
+		/* new head may be missed by an in-progress kmemleak scan */
+		kmemleak_transient_leak(node);
 		shift += RADIX_TREE_MAP_SHIFT;
 	} while (shift <= maxshift);
 out:
@@ -495,8 +497,11 @@ static inline bool radix_tree_shrink(str
 		if (!node->shift && is_idr(root))
 			break;
 
-		if (radix_tree_is_internal_node(child))
+		if (radix_tree_is_internal_node(child)) {
 			entry_to_node(child)->parent = NULL;
+			/* new head may be missed by an in-progress kmemleak scan */
+			kmemleak_transient_leak(entry_to_node(child));
+		}
 
 		/*
 		 * We don't need rcu_assign_pointer(), since we are simply
--- a/tools/testing/shared/linux/kmemleak.h~radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment
+++ a/tools/testing/shared/linux/kmemleak.h
@@ -1 +1,2 @@
 static inline void kmemleak_update_trace(const void *ptr) { }
+static inline void kmemleak_transient_leak(const void *ptr) { }
_

