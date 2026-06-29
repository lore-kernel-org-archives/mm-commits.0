Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CF441930C;
	Mon, 29 Jun 2026 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782751645; cv=none; b=lRVueGduzPt1p1lXyOCeFrccJpXr60DJRbw4ETG0OowWzgLNvhC0HvCPo9iDvKqkriLvdehuhzPnIqXwIl6/rjVk/gpNM5gNlyEC0+7mFyiy5fDOlPJmrFcGz49opdZBwPZDAGIlUGn8HOWSyXxd5z2hkCPGldX+LSMooX5OR7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782751645; c=relaxed/simple;
	bh=0JsWS6PZWtuKTy9rlldkEUWID7MRx6Gl6qI9y59mXBY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=VaV7ovwvIWmnOaqxImUkz3B9urKZo5LZMqdSoWpusf15Ujcyz9yZGiSawFyBho9wpB6e1jEPT41YAV1srpCVrlS1y9vlQb6GdYlmRE8X+O3s3aYtHxiNpGpjY2fMiUESkO+04zrvSNt3aNXsumKCkwkBuyMwa6DklTy6VV39TnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QGYhfnZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QGYhfnZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CEF1F000E9;
	Mon, 29 Jun 2026 16:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782751644;
	bh=fP/oVE9eT26peo2ialtxXs2L/sAlCJhCyJZbMq0zD5I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QGYhfnZ4ueQS79i38OpZt6lJErmX9OSrWULYrn/MP/YlgxuQz7QdVwISHgm6P4s+B
	 P6iPrYkLREZDe879OdYZtNZg9B6uqtgzGvUai9aHKSUEfeH5DMUB3C2YMfaCP88Vl1
	 jd4/7LByyLSEb79RHki+CefebvnunCIbDtD3XJcM=
Date: Mon, 29 Jun 2026 09:47:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Wenchao Hao <haowenchao@xiaomi.com>, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Nhat Pham
 <nphamcs@gmail.com>
Subject: Re: [akpm-mm:mm-new 107/142] mm/zsmalloc.c:800:21: warning:
 'obj_to_class_idx' defined but not used
Message-Id: <20260629094723.806b3136a936b7b061c3b361@linux-foundation.org>
In-Reply-To: <202606291933.Cw5TBs54-lkp@intel.com>
References: <202606291933.Cw5TBs54-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Jun 2026 19:18:51 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   88cefc306c43b58d9bb65c9e96e284306710d961
> commit: b3a8a00229ce2b0367afff075a00d53b92e1234a [107/142] mm/zsmalloc: encode class index in obj value for lockless class lookup
> config: csky-randconfig-001-20260629 (https://download.01.org/0day-ci/archive/20260629/202606291933.Cw5TBs54-lkp@intel.com/config)
> compiler: csky-linux-gcc (GCC) 10.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260629/202606291933.Cw5TBs54-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/zsmalloc.c:800:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]
>      800 | static unsigned int obj_to_class_idx(unsigned long obj)
>          |                     ^~~~~~~~~~~~~~~~

Thanks.  How does this look?

- fix obj_to_class_idx() defined but not used
- remove duplicated #ifdef CONFIG_COMPACTION

 mm/zsmalloc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix
+++ a/mm/zsmalloc.c
@@ -796,12 +796,6 @@ static void obj_to_zpdesc(unsigned long
 	*zpdesc = pfn_zpdesc(obj >> ZS_OBJ_PFN_SHIFT);
 }
 
-/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
-static unsigned int obj_to_class_idx(unsigned long obj)
-{
-	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
-}
-
 /**
  * location_to_obj - encode (<zpdesc>, <obj_idx>, <class_idx>) into obj value
  * @zpdesc: zpdesc object resides in zspage
@@ -1719,9 +1713,12 @@ static void lock_zspage(struct zspage *z
 	}
 	zspage_read_unlock(zspage);
 }
-#endif /* CONFIG_COMPACTION */
 
-#ifdef CONFIG_COMPACTION
+/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
+static unsigned int obj_to_class_idx(unsigned long obj)
+{
+	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
+}
 
 static void replace_sub_page(struct size_class *class, struct zspage *zspage,
 				struct zpdesc *newzpdesc, struct zpdesc *oldzpdesc)
_

