Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794583266;
	b=T2f0RYAjZtp4J6TC4m8/Pw9NdHOosEkt84BNKLfn1qOUCWzHQXI9ndvAzLFd+BdY3ieN
	 cUpuo4aVvcuTfefPACVfHyuMnymmTlVntM5l/0EmBNoaf41RKAJ5GhTaRDE8/GJlAuElJ
	 vImtNfYYMJtJZPbMTeHIib4JzZn7N+kFOmsW+iPnnp3xqxIMnSf5o0UESxbFWdEgz5ZVr
	 73j2+LKKKeUgN/Crelfl1Os2j1WqruMUJG1UjlrHjUKU3QHuiGzmBbsVCwsre2VzdNSyi
	 2pZjzh+qgpZXO0fx2M2UorfC0md/06YEd1v1ONTpDGc2JAGK8TuJoPbVjtImB6AoARA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794583266;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=bU5DE/uhWdiN3flCELkoPLF66Si96iQIuQfP3K+4wkA=;
	b=2/NBrWyjIM9tAaC9mM2+fLhUJk6Wmlmy6md/zKeTld/y7xtM12N8FWEihfse+3SzA8oN
	 A3tXwNaUWlul++RGWcJ6opkh10P93RHy5K/K/evmVZ6bieH6xVMURgBt36JDhZ3WtQpRI
	 RZ08ClcQydlHzo9dknklGz7MjuTyMyEuerltZoi5dKGQV/VKs1GVj1Xa+k3LlQ9ON/X1w
	 j20yhfUtMEAzmBoGO29Tcf04C77h4eOVEB+Of5x/kHHDd5+bScpZH1UgHbnQ5WbDsmXnn
	 X8sBqzKcOF6HcWIlkF9/s5snsfOU6yCLhRLe0pUk/WCEl0Z9jlPO+9GnzaMFfQdvpxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WuY4YJ0r;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D2D606A334
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 15:21:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27D2D606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WuY4YJ0r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794583266; x=1826119266;
  h=date:from:to:cc:subject:message-id;
  bh=L6QYJH9KZ+SbJEA8B7OE4K6jcnlTKs2PVhoOR56VQKQ=;
  b=WuY4YJ0rX/zw8W3XS5N3CDrMKgE6G72Z6zNqt/5/3kXaded3tqX+ptzM
   C3OalVygAVb/AUWYU7MIpE44ee0mVWjBTkxokmb2vo5MTgDqj4dUbzzOL
   qhZmLlay02rplbwciGampZxF1URc5SXshfFX0jfyj+nr4nm+ePRkPxcgw
   ZUfDTFHg+9gUTppUKWB+K8RRgdgyI9NeWRPF+phyLOYUWmSfcqiTp5WWt
   FJ5ZUu4XG2TGUgotUW8NSmipdO626GH9+4+/w1XziC4DP4ZODniqGnJOV
   UnrgVgKtO0A+P2R3+sdJyFwnoU68+V35Q3YBn0Jhp59iY8rEscQBY0Fge
   w==;
X-CSE-ConnectionGUID: trdGiQCdRv6W9Lt9S0DuoA==
X-CSE-MsgGUID: 033A2aIlTriMWfbLC8SDnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3376604"
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="3376604"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 07:21:06 -0800
X-CSE-ConnectionGUID: pC0dXxRSQHe7r7sUecj34Q==
X-CSE-MsgGUID: v0XUbBShR3+ukcwWWO0PAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="9217798"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa008.fm.intel.com with ESMTP; 13 Nov 2026 07:21:03 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRt5H-000000001IB-42Bs;
	Fri, 13 Nov 2026 15:20:59 +0000
Date: Fri, 13 Nov 2026 16:20:51 +0100
From: kernel test robot <lkp@intel.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-nonmm-unstable 130/151]
 fs/squashfs/namei.c:141:21: sparse: sparse: unsigned value that used to be
 signed checked against zero?
Message-ID: <202611131605.L4Uvbf8p-lkp@intel.com>
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
head:   152f0559e66c079f717de375f133ff127afb1f58
commit: 4dddf794b08bef04e5634dd4b52775a160d2cb6c [130/151] Squashfs: sanity check directory metadata block location
config: sh-randconfig-r2307-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131605.L4Uvbf8p-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 16.2.0
sparse: v0.6.5-rc1-21-g84ec0658
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261113/202611131605.L4Uvbf8p-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611131605.L4Uvbf8p-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/squashfs/namei.c:141:21: sparse: sparse: unsigned value that used to be signed checked against zero?
   fs/squashfs/namei.c: note: in included file:
   fs/squashfs/squashfs_helpers.h:79:24: sparse: signed value source

vim +141 fs/squashfs/namei.c

   123	
   124	
   125	static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
   126					 unsigned int flags)
   127	{
   128		const unsigned char *name = dentry->d_name.name;
   129		int len = dentry->d_name.len;
   130		struct inode *inode = NULL;
   131		struct squashfs_sb_info *msblk = dir->i_sb->s_fs_info;
   132		struct squashfs_dir_header dirh;
   133		struct squashfs_dir_entry *dire = NULL;
   134		u64 block = squashfs_dir_start(squashfs_i(dir)->start, msblk);
   135		int offset = squashfs_i(dir)->offset;
   136		int err, length;
   137		unsigned int dir_count, size;
   138	
   139		TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(dir)->start, offset);
   140	
 > 141		if (block < 0)
   142			goto data_error;
   143	
   144		dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
   145		if (dire == NULL) {
   146			ERROR("Failed to allocate squashfs_dir_entry\n");
   147			return ERR_PTR(-ENOMEM);
   148		}
   149	
   150		if (len > SQUASHFS_NAME_LEN) {
   151			err = -ENAMETOOLONG;
   152			goto failed;
   153		}
   154	
   155		length = get_dir_index_using_name(dir->i_sb, &block, &offset,
   156					squashfs_i(dir)->dir_idx_start,
   157					squashfs_i(dir)->dir_idx_offset,
   158					squashfs_i(dir)->dir_idx_cnt, name);
   159	
   160		while (length < i_size_read(dir)) {
   161			/*
   162			 * Read directory header.
   163			 */
   164			err = squashfs_read_metadata(dir->i_sb, &dirh, &block,
   165					&offset, sizeof(dirh));
   166			if (err < 0)
   167				goto read_failure;
   168	
   169			length += sizeof(dirh);
   170	
   171			dir_count = le32_to_cpu(dirh.count) + 1;
   172	
   173			if (dir_count > SQUASHFS_DIR_COUNT)
   174				goto data_error;
   175	
   176			while (dir_count--) {
   177				/*
   178				 * Read directory entry.
   179				 */
   180				err = squashfs_read_metadata(dir->i_sb, dire, &block,
   181						&offset, sizeof(*dire));
   182				if (err < 0)
   183					goto read_failure;
   184	
   185				size = le16_to_cpu(dire->size) + 1;
   186	
   187				/* size should never be larger than SQUASHFS_NAME_LEN */
   188				if (size > SQUASHFS_NAME_LEN)
   189					goto data_error;
   190	
   191				err = squashfs_read_metadata(dir->i_sb, dire->name,
   192						&block, &offset, size);
   193				if (err < 0)
   194					goto read_failure;
   195	
   196				length += sizeof(*dire) + size;
   197	
   198				if (name[0] < dire->name[0])
   199					goto exit_lookup;
   200	
   201				if (len == size && !strncmp(name, dire->name, len)) {
   202					unsigned int blk, off, ino_num;
   203					long long ino;
   204					blk = le32_to_cpu(dirh.start_block);
   205					off = le16_to_cpu(dire->offset);
   206					ino_num = le32_to_cpu(dirh.inode_number) +
   207						(short) le16_to_cpu(dire->inode_number);
   208					ino = squashfs_mkinode(blk, off);
   209	
   210					TRACE("calling squashfs_iget for directory "
   211						"entry %s, inode  %x:%x, %d\n", name,
   212						blk, off, ino_num);
   213	
   214					inode = squashfs_iget(dir->i_sb, ino, ino_num);
   215					goto exit_lookup;
   216				}
   217			}
   218		}
   219	
   220	exit_lookup:
   221		kfree(dire);
   222		return d_splice_alias(inode, dentry);
   223	
   224	data_error:
   225		err = -EIO;
   226	
   227	read_failure:
   228		ERROR("Unable to read directory block [%llx:%x]\n",
   229			squashfs_i(dir)->start, squashfs_i(dir)->offset);
   230	failed:
   231		kfree(dire);
   232		return ERR_PTR(err);
   233	}
   234	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
