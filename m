Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C4A3B530A
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 19:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789414519; cv=none; b=HDQkBX4dAJXfMTl3QnpNBwASKS/dQIin/BIePChMLtfLXoQpUgrXJUrf7+4NHCu3fLOFOegdxo7BUODJV99z/KgxEoyDj/joK0jqV884c8l/aJGHHjsPCfcPs0YM9pqdSF6lq0ey84n0/NDxkh0/j9O1pps/xYANZaSrKw0iJzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789414519; c=relaxed/simple;
	bh=hq6dxowGHUwPIfngdGX/t6v7Rg+VUxbCuQUsmRN9LBk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=mGA4YKRFWBCR23smF1cky+VEWQ3AJ2dAK3gGZmyc6D7va5ZSZvnNS+RhSnzZny9KjOoF4+A9yk0FP22TbIWx/+cR2ocS3zE7qlNAxVKJKFluqZUdWYkqFNu/r1hoqXCyhici7IdWND0C8DrgbZ9wFz1LvN0kifP/wmjeWZNPJ8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t26XuQ42; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t26XuQ42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7171F000FF;
	Mon, 14 Sep 2026 19:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789414518;
	bh=M1W684/6C3WrUebA7SAvM2Es+ZqgospVFCTS6bj5eGE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=t26XuQ42ox5+6PbK0t3SH6X3vdqTZP+pc6Lv4EOLb37XMwA/InExICWlVbQK6kzU9
	 fF3FlWwErQKRorl9jagiVq1n4PI02YOOF8i22B/8BENOlnlNr3zAAjlY+M5WjAhRNw
	 jF5kkiELNbp5zjTWZWE1ugRzUgftZ4idu1Ac1eXQ=
Date: Mon, 14 Sep 2026 12:35:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 383fc05d4650b021f3c17e36a145106dcc61a294
Message-Id: <20260914123517.3be0d96a9535c237bf9125cf@linux-foundation.org>
In-Reply-To: <202609150259.5zswfxI5-lkp@intel.com>
References: <202609150259.5zswfxI5-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Sep 2026 02:10:03 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 383fc05d4650b021f3c17e36a145106dcc61a294  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202609121422.hkKWuy7K-lkp@intel.com
> 
>     fs/proc/task_mmu.c:187:13: warning: 'drop_rcu' defined but not used [-Wunused-function]
>     fs/proc/task_mmu.c:195:13: warning: 'reacquire_rcu' defined but not used [-Wunused-function]

Thanks.  Suren's "proc/task_mmu: remove unnecessary inlines in function
definitions" didn't like

# CONFIG_PROC_PAGE_MONITOR is not set
# CONFIG_NUMA is not set

I'll dial that back a bit:

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
+++ a/fs/proc/task_mmu.c
@@ -130,7 +130,7 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	int ret = mmap_read_lock_killable(lock_ctx->mm);
 
@@ -194,7 +194,7 @@ static bool fallback_to_mmap_lock(struct
 	return true;
 }
 
-static void drop_rcu(struct proc_maps_private *priv)
+static inline void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
@@ -202,7 +202,7 @@ static void drop_rcu(struct proc_maps_pr
 	rcu_read_unlock();
 }
 
-static void reacquire_rcu(struct proc_maps_private *priv)
+static inline void reacquire_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
_

