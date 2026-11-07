Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794053258;
	b=zVW0Uq/42PMclYGoAX5SVObLnx5fdcfxDdoVGPAxWnzpEOx24DDCUehWJaqon0F3XU+M
	 O0paoasQzqdVztYYt2NiPPVWViFzdlRVVTXODtFuQxbd5/3q8nm/etmq6LrC+aUK/iwwV
	 AWJyfGTgRkl9KydM2X5Qnzjh2lX19WJDkWgGppCefysfdn29XkqFNdqLIsiQByr+nq2nK
	 4sC85J0Yj2g/1AMywehZhM/tpKLcD78UtFV/dsB417gNUT1I42SlW9L+ATtzTImPymDmX
	 35RgGLOpGT0m7GDEFyMmajefxvSKFgf5fDLSyRIpjPfm94CjwVz4dcf06LklRP/T8FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794053258;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=2qaGDM5KXwo/XbIElFXbZo2pyoRiYC1SBXqYkAOocig=;
	b=aWKOWMW0K9Ou8EZIRZ43Ki4uRgcUyM+seQpcGyNiAFKozTIgOMC/Vvf3mChluvqFNDy/
	 HpiRT/wjv0N5B4P0x3AEqGjAlrHIw6n89qSM48LDlUdO2cMvjChXCMffCMiCRBV8nevcq
	 8Rn7dkhWwWFtWVBx1LIW+xGOq1hiRAEqReT5/vPN4aHSbKQuS+P8YehgMGC4cJnPn2+Dz
	 VvS9j/6VB41T2msPd4z4KTmjfQpPFPD6HZ8kljXhAH6shPmUF1Iv4EiAX9PhKS+rHkftc
	 2x5xBTVBn0nz77FGEuG3zuBqLeBlKmV904rJVcvQKwRNKyDZ/zLf/OjqIXqKxlYI5zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WqVgQ9D4;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AEE606A32C
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 12:07:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0AEE606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WqVgQ9D4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794053257; x=1825589257;
  h=date:from:to:cc:subject:message-id;
  bh=d5ZgnRix7VXOje43U+Fy8zm1siik98+UBrQqZUXZte0=;
  b=WqVgQ9D4XwRNopqkE7bIgtn0ku/QxEoPCLK3EaqeA/o54fSdAAhLQNsN
   We++mrudTCFSQcjMr26llV9Kye+wGNJQGKsORnIm8pM4HiSZ1wkyv7M+A
   eZI0NgAuEJ73Ru+6dSKzwEXZqCqFcsiW4LvgXGjUV808CSc2WfclQ94Cn
   ELgLCWNhZAerKsyd0S1DNnhBuzchLZgbOBKzoZTsJYw6ACWFJHywxSj6E
   9N4RM/QBQoET0y+4GWMRNvvXf43tJTPNHv2K3pKLwPxQ/IiRd6ulka8Mw
   CtcR3qzmTPyHh0GVwtvKSLEpT8L4xZP0GN4OWpgfRUakd5ivkDfrMGFGx
   g==;
X-CSE-ConnectionGUID: g/dN81pIQhyxbqh9GY8uhQ==
X-CSE-MsgGUID: +DdqzwriTkSzHQheGjLEQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11958"; a="2843805"
X-IronPort-AV: E=Sophos;i="6.27,200,1787036400"; 
   d="scan'208";a="2843805"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2026 04:07:36 -0800
X-CSE-ConnectionGUID: TLXXnBsYSx2KDOSdQ88oBA==
X-CSE-MsgGUID: qXskRPm+S0G7tL3WCjG0ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,200,1787036400"; 
   d="scan'208";a="7354265"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 07 Nov 2026 04:07:33 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xPfCj-00000000qnp-2xYU;
	Sat, 07 Nov 2026 12:07:29 +0000
Date: Sat, 07 Nov 2026 20:06:32 +0800
From: kernel test robot <lkp@intel.com>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Phillip Lougher <phillip@squashfs.org.uk>
Subject: [akpm-mm:mm-nonmm-unstable 111/117]
 fs/squashfs/file_direct.c:121:1: warning: label 'out' defined but not used
Message-ID: <202611072044.cmq8jkLA-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   09658a93dbdf3596b7c0edec1292ae09e58da333
commit: 024c3b9753561e3ad2d6cdd47b405126709633e0 [111/117] squashfs: fix leaked page locks when page actor allocation fails
config: i386-buildonly-randconfig-1001-20261107 (https://download.01.org/0day-ci/archive/20261107/202611072044.cmq8jkLA-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261107/202611072044.cmq8jkLA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611072044.cmq8jkLA-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/squashfs/file_direct.c: In function 'squashfs_readpage_block':
>> fs/squashfs/file_direct.c:121:1: warning: label 'out' defined but not used [-Wunused-label]
     121 | out:
         | ^~~


vim +/out +121 fs/squashfs/file_direct.c

0d455c12c642864 Phillip Lougher         2013-11-13   20  
0d455c12c642864 Phillip Lougher         2013-11-13   21  /* Read separately compressed datablock directly into page cache */
2a7aea59cf4dd4a Matthew Wilcox (Oracle  2024-12-20   22) int squashfs_readpage_block(struct folio *folio, u64 block, int bsize,
a3f94cb99a854fa Phillip Lougher         2018-08-02   23  		int expected)
0d455c12c642864 Phillip Lougher         2013-11-13   24  {
2a7aea59cf4dd4a Matthew Wilcox (Oracle  2024-12-20   25) 	struct page *target_page = &folio->page;
2a7aea59cf4dd4a Matthew Wilcox (Oracle  2024-12-20   26) 	struct inode *inode = folio->mapping->host;
0d455c12c642864 Phillip Lougher         2013-11-13   27  	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
12427de9439d68b Phillip Lougher         2023-11-13   28  	loff_t file_end = (i_size_read(inode) - 1) >> PAGE_SHIFT;
09cbfeaf1a5a67b Kiryl Shutsemau         2016-04-01   29  	int mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
7f73fcde4d93072 Phillip Lougher         2024-08-19   30  	loff_t start_index = folio->index & ~mask;
12427de9439d68b Phillip Lougher         2023-11-13   31  	loff_t end_index = start_index | mask;
d31638ff6c5437c Phillip Lougher         2024-10-21   32  	loff_t index;
d31638ff6c5437c Phillip Lougher         2024-10-21   33  	int i, pages, bytes, res = -ENOMEM;
7f73fcde4d93072 Phillip Lougher         2024-08-19   34  	struct page **page, *last_page;
0d455c12c642864 Phillip Lougher         2013-11-13   35  	struct squashfs_page_actor *actor;
0d455c12c642864 Phillip Lougher         2013-11-13   36  	void *pageaddr;
0d455c12c642864 Phillip Lougher         2013-11-13   37  
0d455c12c642864 Phillip Lougher         2013-11-13   38  	if (end_index > file_end)
0d455c12c642864 Phillip Lougher         2013-11-13   39  		end_index = file_end;
0d455c12c642864 Phillip Lougher         2013-11-13   40  
0d455c12c642864 Phillip Lougher         2013-11-13   41  	pages = end_index - start_index + 1;
0d455c12c642864 Phillip Lougher         2013-11-13   42  
14694888db2c1f7 Fabian Frederick        2014-08-06   43  	page = kmalloc_array(pages, sizeof(void *), GFP_KERNEL);
0d455c12c642864 Phillip Lougher         2013-11-13   44  	if (page == NULL)
0d455c12c642864 Phillip Lougher         2013-11-13   45  		return res;
0d455c12c642864 Phillip Lougher         2013-11-13   46  
0d455c12c642864 Phillip Lougher         2013-11-13   47  	/* Try to grab all the pages covered by the Squashfs block */
d31638ff6c5437c Phillip Lougher         2024-10-21   48  	for (i = 0, index = start_index; index <= end_index; index++) {
d31638ff6c5437c Phillip Lougher         2024-10-21   49  		page[i] = (index == folio->index) ? target_page :
2a7aea59cf4dd4a Matthew Wilcox (Oracle  2024-12-20   50) 			grab_cache_page_nowait(folio->mapping, index);
0d455c12c642864 Phillip Lougher         2013-11-13   51  
1bb1a07afad9730 Phillip Lougher         2022-06-11   52  		if (page[i] == NULL)
0d455c12c642864 Phillip Lougher         2013-11-13   53  			continue;
0d455c12c642864 Phillip Lougher         2013-11-13   54  
0d455c12c642864 Phillip Lougher         2013-11-13   55  		if (PageUptodate(page[i])) {
0d455c12c642864 Phillip Lougher         2013-11-13   56  			unlock_page(page[i]);
09cbfeaf1a5a67b Kiryl Shutsemau         2016-04-01   57  			put_page(page[i]);
1bb1a07afad9730 Phillip Lougher         2022-06-11   58  			continue;
0d455c12c642864 Phillip Lougher         2013-11-13   59  		}
0d455c12c642864 Phillip Lougher         2013-11-13   60  
1bb1a07afad9730 Phillip Lougher         2022-06-11   61  		i++;
0d455c12c642864 Phillip Lougher         2013-11-13   62  	}
0d455c12c642864 Phillip Lougher         2013-11-13   63  
1bb1a07afad9730 Phillip Lougher         2022-06-11   64  	pages = i;
1bb1a07afad9730 Phillip Lougher         2022-06-11   65  
f268eedddf3595e Phillip Lougher         2022-06-11   66  	/*
f268eedddf3595e Phillip Lougher         2022-06-11   67  	 * Create a "page actor" which will kmap and kunmap the
f268eedddf3595e Phillip Lougher         2022-06-11   68  	 * page cache pages appropriately within the decompressor
f268eedddf3595e Phillip Lougher         2022-06-11   69  	 */
2258e22f05aff58 Phillip Lougher         2024-08-19   70  	actor = squashfs_page_actor_init_special(msblk, page, pages, expected,
2258e22f05aff58 Phillip Lougher         2024-08-19   71  						start_index << PAGE_SHIFT);
f268eedddf3595e Phillip Lougher         2022-06-11   72  	if (actor == NULL)
024c3b9753561e3 Nguyen Ngoc Thang       2026-09-27   73  		goto mark_errored;
f268eedddf3595e Phillip Lougher         2022-06-11   74  
0d455c12c642864 Phillip Lougher         2013-11-13   75  	/* Decompress directly into the page cache buffers */
0d455c12c642864 Phillip Lougher         2013-11-13   76  	res = squashfs_read_data(inode->i_sb, block, bsize, NULL, actor);
f268eedddf3595e Phillip Lougher         2022-06-11   77  
7f73fcde4d93072 Phillip Lougher         2024-08-19   78  	last_page = squashfs_page_actor_free(actor);
f268eedddf3595e Phillip Lougher         2022-06-11   79  
0d455c12c642864 Phillip Lougher         2013-11-13   80  	if (res < 0)
0d455c12c642864 Phillip Lougher         2013-11-13   81  		goto mark_errored;
0d455c12c642864 Phillip Lougher         2013-11-13   82  
84e0e03b308816a Phillip Lougher         2024-08-23   83  	if (res != expected || IS_ERR(last_page)) {
a3f94cb99a854fa Phillip Lougher         2018-08-02   84  		res = -EIO;
a3f94cb99a854fa Phillip Lougher         2018-08-02   85  		goto mark_errored;
a3f94cb99a854fa Phillip Lougher         2018-08-02   86  	}
a3f94cb99a854fa Phillip Lougher         2018-08-02   87  
1bb1a07afad9730 Phillip Lougher         2022-06-11   88  	/* Last page (if present) may have trailing bytes not filled */
09cbfeaf1a5a67b Kiryl Shutsemau         2016-04-01   89  	bytes = res % PAGE_SIZE;
7f73fcde4d93072 Phillip Lougher         2024-08-19   90  	if (end_index == file_end && last_page && bytes) {
7f73fcde4d93072 Phillip Lougher         2024-08-19   91  		pageaddr = kmap_local_page(last_page);
09cbfeaf1a5a67b Kiryl Shutsemau         2016-04-01   92  		memset(pageaddr + bytes, 0, PAGE_SIZE - bytes);
1bb1a07afad9730 Phillip Lougher         2022-06-11   93  		kunmap_local(pageaddr);
0d455c12c642864 Phillip Lougher         2013-11-13   94  	}
0d455c12c642864 Phillip Lougher         2013-11-13   95  
0d455c12c642864 Phillip Lougher         2013-11-13   96  	/* Mark pages as uptodate, unlock and release */
0d455c12c642864 Phillip Lougher         2013-11-13   97  	for (i = 0; i < pages; i++) {
0d455c12c642864 Phillip Lougher         2013-11-13   98  		flush_dcache_page(page[i]);
0d455c12c642864 Phillip Lougher         2013-11-13   99  		SetPageUptodate(page[i]);
0d455c12c642864 Phillip Lougher         2013-11-13  100  		unlock_page(page[i]);
0d455c12c642864 Phillip Lougher         2013-11-13  101  		if (page[i] != target_page)
09cbfeaf1a5a67b Kiryl Shutsemau         2016-04-01  102  			put_page(page[i]);
0d455c12c642864 Phillip Lougher         2013-11-13  103  	}
0d455c12c642864 Phillip Lougher         2013-11-13  104  
0d455c12c642864 Phillip Lougher         2013-11-13  105  	kfree(page);
0d455c12c642864 Phillip Lougher         2013-11-13  106  
0d455c12c642864 Phillip Lougher         2013-11-13  107  	return 0;
0d455c12c642864 Phillip Lougher         2013-11-13  108  
0d455c12c642864 Phillip Lougher         2013-11-13  109  mark_errored:
bbf45b7e6855556 Matthew Wilcox (Oracle  2024-04-20  110) 	/* Decompression failed.  Target_page is
0d455c12c642864 Phillip Lougher         2013-11-13  111  	 * dealt with by the caller
0d455c12c642864 Phillip Lougher         2013-11-13  112  	 */
0d455c12c642864 Phillip Lougher         2013-11-13  113  	for (i = 0; i < pages; i++) {
6d565409503f4e1 Phillip Lougher         2013-11-24  114  		if (page[i] == NULL || page[i] == target_page)
0d455c12c642864 Phillip Lougher         2013-11-13  115  			continue;
0d455c12c642864 Phillip Lougher         2013-11-13  116  		flush_dcache_page(page[i]);
0d455c12c642864 Phillip Lougher         2013-11-13  117  		unlock_page(page[i]);
09cbfeaf1a5a67b Kiryl Shutsemau         2016-04-01  118  		put_page(page[i]);
0d455c12c642864 Phillip Lougher         2013-11-13  119  	}
0d455c12c642864 Phillip Lougher         2013-11-13  120  
0d455c12c642864 Phillip Lougher         2013-11-13 @121  out:

:::::: The code at line 121 was first introduced by commit
:::::: 0d455c12c6428647547bacccaaced3cae0f35570 Squashfs: Directly decompress into the page cache for file data

:::::: TO: Phillip Lougher <phillip@squashfs.org.uk>
:::::: CC: Phillip Lougher <phillip@squashfs.org.uk>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
