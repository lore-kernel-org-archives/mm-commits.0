Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794808677;
	b=gN9nhetgOjaLgtP67E7g2XdhSqsc5ovmfZ44p9DHIOGVKJi6EXbZjeduq2c5lY/QAaME
	 /rzZ3FWg6oRyjOCe2LkSAy1sHkMU4COwqytTRKB0E1YGusOKkrW8m8A7DDEg12Qi3Nhyz
	 zF6COzuudg+4qXX2VizYeCPIrjkrlctd6NoVjT1D0quJEOMrYAbDY26ktWEhhcFhr300h
	 JvNdKaPIps8IEu43CY2bdw4csG7qtW8+CcjuzVuS0vzxcXO6oleq357cJZaPeQJB93tCB
	 Xg2gryCzyHVxOEMX72gWmeydqpnmcn0cIEgu4nKt++ZeooWfbaiDOiLbc8Zn2Qro+3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794808677;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=bxSArsxaCkviuzkJwRXAaqradlVMZJysA2PPJZZMFoU=;
	b=OjdAlbOeDoskQbZXktPXYbyHPOz8kF8z56PTbWMl7EYKUZBZyuwKaL2zpQVFCXCPYmyi
	 IauNgxnpGAH3yC1xlyH5SOLxV779zUPZzX9nK+A2INGpL/6Twe9NTrnAwGNv2+8ijRlv3
	 05wpgMJ/4D38/7BpKxRbrxmkVxshOPrV9T2AlmeCeURHuySDV4SUfvVZxt6ysPCsiujsY
	 95wOQunAghSMn92QU3Sbq7F1ey3nnpvcQT/k+6KpqPsKBLtZKQxAkAHBQoW+Ojnv1oseK
	 HFV8hsLgDMnXxLfjs+FlSicvTPYk9Y9URgpM/CwhBSfeuU5x8j4EwgXSHiSGPqvygOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=c78odPp8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71048606A32A;
	Mon, 16 Nov 2026 05:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=c78odPp8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D531F000C4;
	Mon, 16 Nov 2026 05:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794808677;
	bh=bxSArsxaCkviuzkJwRXAaqradlVMZJysA2PPJZZMFoU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=c78odPp8OJft1v91gLdhRaAMxTlGLixH+0rokNUgBdtZ2JsYkZdgy6zWS84DUY4Lt
	 zV3T5byWolVfUj8r/gfr4x4hvaY+ABQlY0Z9I3znscYfDE72a6DSXRQE2ylHk4jnlR
	 NL6GBkm63tQ//yo+x+/TrniHsmhYwWdkNg0BC8cw=
Date: Sun, 15 Nov 2026 21:57:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <error27@gmail.com>
Cc: oe-kbuild@lists.linux.dev, Phillip Lougher <phillip@squashfs.org.uk>,
 lkp@intel.com, oe-kbuild-all@lists.linux.dev, David Hildenbrand
 <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-nonmm-unstable 139/151] fs/squashfs/namei.c:283
 squashfs_lookup() warn: passing zero to 'ERR_PTR'
Message-Id: <20261115215756.839150412f8e2ce4bab5105c@linux-foundation.org>
In-Reply-To: <202611131955.0Gd7ipSP-lkp@intel.com>
References: <202611131955.0Gd7ipSP-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 16 Nov 2026 08:26:18 +0300 Dan Carpenter <error27@gmail.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> head:   152f0559e66c079f717de375f133ff127afb1f58
> commit: 5213b0a08263b2191b86b046c3a63f11e8abc399 [139/151] Squashfs: fix variables in directory code and add more sanity checks
> config: um-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131955.0Gd7ipSP-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
> smatch: v0.5.0-9187-g5189e3fb
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <error27@gmail.com>
> | Closes: https://lore.kernel.org/r/202611131955.0Gd7ipSP-lkp@intel.com/
> 
> New smatch warnings:
> fs/squashfs/namei.c:283 squashfs_lookup() warn: passing zero to 'ERR_PTR'

OK.

> 5213b0a08263b21 Phillip Lougher 2026-11-11  224  			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
> 5213b0a08263b21 Phillip Lougher 2026-11-11  225  				goto read_failure;
> 
> We need an error code on this path.
> 

How's this?

--- a/fs/squashfs/namei.c~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix
+++ a/fs/squashfs/namei.c
@@ -221,8 +221,10 @@ static struct dentry *squashfs_lookup(st
 			/*
 			 * Read directory entry.
 			 */
-			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
+			if (!squashfs_dir_space(dir, length, sizeof(*dire))) {
+				err = -ENOSPC;
 				goto read_failure;
+			}
 
 			err = squashfs_read_metadata(dir->i_sb, dire, &block,
 					&offset, sizeof(*dire));
_

