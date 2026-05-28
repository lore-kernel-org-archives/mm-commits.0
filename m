Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230EC367B93;
	Thu, 28 May 2026 22:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780006581; cv=none; b=X0UEGlpfmoIcO7en/fIWbc7L6Hw1ahp2mjJsSrs0BtR728PaPWPbpCnsOOFCcQzuv8kQXR4rS9foCjk8mwjbzJzoT8xlpITep6E8dkc++LvDk+FpaHjpA8EUDuwXEPoZDxlVL7TyjYc34mi4HguQDWbEAeVG38cEpiZ+AI1IgZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780006581; c=relaxed/simple;
	bh=EtfFqm6J96FrTAXa40Zo94HO6Jm4SlbaWU14omsN8CE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=WRze22Wi1e+See7TCX0QHE/ll6hUqfJ9ETMfoqnvVCqqKcHgOJdXYfGo3dR/ePzIlK9VdggBAj+wmE1aIyQdusMZCSxkDTP23/TavgTLLFvv5+7H/mVIh3IueEWjGaIkjJiTnNZc09RaNOBxWDA5YNqJFcH7t4Y1LxAxKdkvxs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DN6I2KP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DN6I2KP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB7B1F000E9;
	Thu, 28 May 2026 22:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780006579;
	bh=TLt+xHl/igW7/uoHhFaIthjEDGE139MNPnu6HA06LIU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DN6I2KP87TaWhV4j9oHEQulEmdSIIbTijdb/JUVsfocZfVpmH44cjfqgGx0PedIqz
	 lrahMH/RZxsTViyuI9balSrw9AB59WLtNgbIdz+AveEn4St2UJKk0KnMC7we0VEEgb
	 +16AvK+/Ql2ILs0DX40GGLfV2k+hdAP52r412G6U=
Date: Thu, 28 May 2026 15:16:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [akpm-mm:mm-new 429/433] mm/swap_state.c:468:19: error: call to
 undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not
 support implicit function declarations
Message-Id: <20260528151618.7aa255415825c8d1de6ca437@linux-foundation.org>
In-Reply-To: <202605281620.lc3rtkBm-lkp@intel.com>
References: <202605281620.lc3rtkBm-lkp@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 May 2026 16:15:31 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   d7d405cc33d6e3eeba2d6ec8f0b595da2a5c600a
> commit: a5e62d9e00dac6f96174c397a82da30e7ae53064 [429/433] mm: switch deferred split shrinker to list_lru
> config: hexagon-defconfig (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605281620.lc3rtkBm-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> mm/swap_state.c:468:19: error: call to undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      468 |         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>          |                          ^
>    1 error generated.

Thanks.  How does this look?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-switch-deferred-split-shrinker-to-list_lru-fix
Date: Thu May 28 03:12:45 PM PDT 2026

fix build with CONFIG_TRANSPARENT_HUGEPAGE=n

| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281620.lc3rtkBm-lkp@intel.com/
Link: https://lore.kernel.org/202605281620.lc3rtkBm-lkp@intel.com
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/include/linux/huge_mm.h~mm-switch-deferred-split-shrinker-to-list_lru-fix
+++ a/include/linux/huge_mm.h
@@ -663,7 +663,15 @@ static inline int folio_split(struct fol
 	return -EINVAL;
 }
 
-static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
+static inline int folio_memcg_alloc_deferred(struct folio *folio)
+{
+	return 0;
+}
+
+static inline void deferred_split_folio(struct folio *folio, bool partially_mapped)
+{
+}
+
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
_

