Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585787;
	b=gMi9/WDaVw2wt+mlcs2jqU74naA2bNo5P/RO8sUShhreLoFMn6NZVNk3Hz0/QrsClN4V
	 UBb+C/G7GG7+EtbGXLKQTVbWPMr2eYwZaorb1mAlgqwRhWLOv4t2//Xr7CLX7p+XZZYvr
	 zCxLgymBsCf0xoMWERV6Y71uRF9qX71Rn+cSAY+M9zVt1z5wzrJ1ezkrxJYU7kDt5DQbp
	 CefSFf+V6zOXQF9CWidk6GolznQJrPmpNjgGBr6AZ8NhVq/WRMIcGIdyRo0XQO2T1mRqO
	 bJJSQ0w6DnRLvhgfqUKH8gKO50U1yEfkFIeQG1rq9Lm/w+KuaqnemuUSDCMqR66J7sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585787;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=lv8NvC7HZDwkKZVoXw+7O2h5gIlJbnwmSDVX+2upUUs=;
	b=ORJtmfXJ1BS+GlA7AC4VX9eGeYTp5vqwcT/9eqkGe6FJaF6q/B9iMKSnSJrNfoF4tTxI
	 kymuHftrgCl3Gl1IUXiQbnPGNzeKBx5y46JL+O0YSCMPEkCS6gc0QRdK0G5f8zOwOq3eE
	 gLwvUyKKnLzzLpFQxO6ogIiRLYFidOze7Z5iGweDJQIMLIKRBG+UWd5QQb6mO0xHaAzde
	 XCaJ0jIeEg/vrqWQNbDiIvL7it1OGzgEPNyFexUOP4VNymjFOWGEGQlXqJ0TntKHq0Bmo
	 iPPTmxS3G+4VLrZwXzFvC/ElId5sS9dZHZI4hUUuh+waomT4lKOoP3HS1+uPco+5Z5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MijHPcsQ;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6E6606D473
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 16:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E6E6606D473
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MijHPcsQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794585787; x=1826121787;
  h=date:from:to:cc:subject:message-id;
  bh=iTh6WixWUDEbiKZbg0v39EPO5GHw8FrjoVYrf52zqFs=;
  b=MijHPcsQt5Yszq90yQvE70aeu7HVcRtAD5KCu9Gk24MUYScUxmMExqXC
   oOZ4x6T9iEumQ1RWpOguwiplRnzzWYi4kuhocXykXNUCCMa7OURZGEWAL
   5dt4WTmSUHJhirA4FwDrd7AP4hqzb7OCYgjDk1WDco1fNpQbzfTAcfOlX
   VB965lL09GTi7TUlFrlFYL7wGmYJuM8IA54DU0Tel8hvMtIkP5XxRXcLK
   UMlsWFZHnWtFXwPXlzWwSYM53GYtKNzc7V/QxU8z9nW87bX0VCQI0MmsG
   aibjoJbKc4TuohOiw/1ni5JoYYlJyq64P39K1+YX0vlZg+Ztnlg8JIyCp
   w==;
X-CSE-ConnectionGUID: EPd9l3sLT0q0eDKPnjNt8w==
X-CSE-MsgGUID: IxDeFWiJRYylp5KB6kt6Aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3387170"
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="3387170"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 08:03:06 -0800
X-CSE-ConnectionGUID: Jn5E5HN0Q2SBwu/Ed/juJg==
X-CSE-MsgGUID: rMENWAhJSS+2U0SLEh4nqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="9118710"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 13 Nov 2026 08:03:03 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRtjx-000000001Id-0UlJ;
	Fri, 13 Nov 2026 16:03:01 +0000
Date: Fri, 13 Nov 2026 17:02:14 +0100
From: kernel test robot <lkp@intel.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-nonmm-unstable 130/151] fs/squashfs/namei.c:141
 squashfs_lookup() warn: unsigned 'block' is never less than zero.
Message-ID: <202611131701.jmNjTw9l-lkp@intel.com>
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
config: um-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131701.jmNjTw9l-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
smatch: v0.5.0-9187-g5189e3fb

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611131701.jmNjTw9l-lkp@intel.com/

smatch warnings:
fs/squashfs/namei.c:141 squashfs_lookup() warn: unsigned 'block' is never less than zero.
fs/squashfs/namei.c:141 squashfs_lookup() warn: error code type promoted to positive: 'block'

vim +/block +141 fs/squashfs/namei.c

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
