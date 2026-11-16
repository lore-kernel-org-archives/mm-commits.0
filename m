Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794806784;
	b=iuaZ/VIY6RVq0Whd6fHcTKHxpeEVFSHI8/bVktcHegN5Ug4O9DDs+HdlBqgjjtdxRPig
	 dy8IcMO5WkZ96au35yCpyEEnd49evOkbR3e0jDWJSaYPmUG3LlUmNwVIEZ9ZrQYrNSido
	 Mly/W1wi/6PJ6Za8IiMzvy+MZBumlhuogLbGv6/lUImt+U3tn/Qnin+xB3wYZLyHvGq2k
	 ljj9tHcyU37M0cn7GUjABcEmqEJ5+53wVe9hRP9OTOmszGUSHCdaJm+emHgDEji5PuFvV
	 jM3o+Km4AQ/mbPTOeojYAPFhfyCzW7Lu/uTjs4mVzC/avBqXlF24ZJ0fZjFP231eSCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794806784;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition;
	bh=hz56qYSOSs9DQhsj5maa5eeVQHnnDEv1CGruA/BwN70=;
	b=lVJDUJ4+fMbSBAj/1TLyPLhGw7eOJ5G7mNoUH5g3ST4pnGMw4E3Xb8Lv6bdxN9hctJW3
	 /9r881ifaAvIxdvwoRkzz6vLNSZYkKDPM/xmI2RJTIoffIRzwmJ/hTA6wfLuK8CnBMUik
	 /4qNFiwg1QrPeYO7pvY3y1oa+wzyaD949BMu7eSsu8LBnw8XtddIfIjd/zrtmd4fwRrCt
	 qupKD+Xg0q/YJ+jpDlEFqTD1PrhUQNFuZ5U8XyhEkM+PLSyJy7arXqNfua7H5NatZNfxK
	 5DQlKjwEJRIwWtG9M2kqxqVf4+udGYyWidDkKdwQvbYfQkN7CJWpm1sHzTE0tRCWCYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PJVAU4q1;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B0C606A32A
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 05:26:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81B0C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PJVAU4q1
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e09aa5264so1348799f8f.2
        for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 21:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794806783; x=1795411583; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hz56qYSOSs9DQhsj5maa5eeVQHnnDEv1CGruA/BwN70=;
        b=PJVAU4q1cveSGIOdYdtJerRvAyDymMEBeWkKs7NM4FTX1CIp3gbonB+2at809jZ0+x
         AQqaJXU277neaAv/cRJik4HtGI07qxQzD/4eHY4qTcbl4H0epczz687zUJmy48thT0yd
         gl8ZYt9BJNY9H5bvdwnXxEfO2FE5hiWiTtyb20Xr2LB4zkifO2jorU+ueMjy7HdVjZnU
         bFVOk13NnP+eigXJzHQtUwnZs9vlFuUPxQ6eM4wL41GGsTxPUojLJhY8RcCLGxkVbjAT
         lg1vRyfD0dMYWn19GO7TaX4BApNquXBUs1XqJDEsAH8NbBY14J6Vh2QPCZyQ1UkHamcR
         ukag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794806783; x=1795411583;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hz56qYSOSs9DQhsj5maa5eeVQHnnDEv1CGruA/BwN70=;
        b=K/aA2nMtCwixmahEt8vrm1dFOfRP9hBpzHEBP7TDb1Xb8qNbU+uLxSPCJmNDUkhx1M
         PVDBrbMxlu+sPuViBxgGca+DosVRTuZeMJBDG84vLA6HZFzqxOW9jPaa/eUaWZuFDWEM
         hkiMlgOdpslyiOIZLU3wsLx1ZH7iNrjcjGb2q3xkyg4nKcyUaRO4aVXwqY3TgDLoi6Jh
         giKLpb1s4kHKiEaudPIIup44L8KXVeHnSpJgBNi67CdP18euIpp3AcCUbqjADznPvAw3
         GFuIgSoeDKI0zmDU7TX7MUQOsdqOBPj1NoTHlR64clj2xlgrlpztTVnk7EQ6/+dIEL2n
         6uVQ==
X-Forwarded-Encrypted: i=1; AL+hErFdtCcWo0Za6Z5QI9kOFmEtS242caW6z8BrzHbBuLW8RxOVRnvdhbO9JTY9UEDVi/4QHA74Jd43wFvg@vger.kernel.org
X-Gm-Message-State: APuU4Z+PtX5J7TDgA6bSfRglKI87JN3nQx62jD8LQ8HO+8W2MKEyjm+j
	+xlmfjoUdh8LsS9JstUoAwmYWQ/P6FlS6n+o6U5vlovx2KyC6hziEwEPQ5gtoWN8jyKDrQFA
X-Gm-Gg: AYBFou2GJRRvcWik9ECKoM/ZKj4wAYqYU7C5NyAdiENCSzQOnwY5KmEKKtw1qvLrFre
	r6AcNmqGcWB5zTQoefaY6BQ9sWKTMC2m02kJQlSv0AKz7Q0if8/UiPS40/LYfQKFd+BIC/38reA
	LjK7X/BYIWLiKUNybJ4MyBT8AcdT0C6Wu4WilTrM2HoiX0s8+Xdo60bXXlEgdPIxyD7Ef+kORGG
	kDz0C89B51Zqvz6uDSknEOlFyZMmvHifXkmuX3yyCbNXPDIKjyGp424TWsShOeGPvXgjjE3CeA/
	z7tHMxTXtcYVc57XRE8lurlJJcZ79uDH1Ae1scqzEU1NU6GoD3G8qylKiWhQ+n9A265ZfYo+UNb
	LVdCaZJ3FLoXY9b6IANZW30C8Z4CCEETZVP2wMv77T9YC3MWvM0AyzTB9rTlHPowgveoV/MsFwB
	SMiOL6Cs2rCYmfIQrsIWIwYIPulk/Fe4warx1I0ZC9mj6RNbBEqng8cgoQuxSTbHtD/e2ltzOtF
	rjJ+ksvPSSkuAaSMA+ROljmOr/e7v4s0SkYMmLPyUUBKIFHfg3LQWpZT7bv1l46hUY8tli5+g3U
	gFmEyq4wLNaAOLPnf8sDk8qQKdNftnczGNge7BrR6VZSQtR+RDnmpgkPPy101YmMwXafk1NCRsx
	WADYS6abjEJYg5wqdEVD5BYi+qcMi1MiHwoqrVi7WcQA9Ri0ENeWDkVm/HSCE6StN+PQ=
X-Received: by 2002:a05:6000:26c8:b0:491:8462:20cc with SMTP id ffacd0b85a97d-49c73ce5e65mr21515228f8f.37.1794806782617;
        Sun, 15 Nov 2026 21:26:22 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60da0a03sm16137617f8f.53.2026.11.15.21.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 21:26:22 -0800 (PST)
Date: Mon, 16 Nov 2026 08:26:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: oe-kbuild@lists.linux.dev, Phillip Lougher <phillip@squashfs.org.uk>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-nonmm-unstable 139/151] fs/squashfs/namei.c:283
 squashfs_lookup() warn: passing zero to 'ERR_PTR'
Message-ID: <202611131955.0Gd7ipSP-lkp@intel.com>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   152f0559e66c079f717de375f133ff127afb1f58
commit: 5213b0a08263b2191b86b046c3a63f11e8abc399 [139/151] Squashfs: fix variables in directory code and add more sanity checks
config: um-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131955.0Gd7ipSP-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
smatch: v0.5.0-9187-g5189e3fb

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Closes: https://lore.kernel.org/r/202611131955.0Gd7ipSP-lkp@intel.com/

New smatch warnings:
fs/squashfs/namei.c:283 squashfs_lookup() warn: passing zero to 'ERR_PTR'

vim +/ERR_PTR +283 fs/squashfs/namei.c

c88da2c979369e6 Phillip Lougher 2009-01-05  164  static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
00cd8dd3bf95f2c Al Viro         2012-06-10  165  				 unsigned int flags)
c88da2c979369e6 Phillip Lougher 2009-01-05  166  {
c88da2c979369e6 Phillip Lougher 2009-01-05  167  	const unsigned char *name = dentry->d_name.name;
c88da2c979369e6 Phillip Lougher 2009-01-05  168  	int len = dentry->d_name.len;
c88da2c979369e6 Phillip Lougher 2009-01-05  169  	struct inode *inode = NULL;
c88da2c979369e6 Phillip Lougher 2009-01-05  170  	struct squashfs_sb_info *msblk = dir->i_sb->s_fs_info;
c88da2c979369e6 Phillip Lougher 2009-01-05  171  	struct squashfs_dir_header dirh;
4dddf794b08bef0 Phillip Lougher 2026-11-11  172  	struct squashfs_dir_entry *dire = NULL;
4dddf794b08bef0 Phillip Lougher 2026-11-11  173  	u64 block = squashfs_dir_start(squashfs_i(dir)->start, msblk);
c88da2c979369e6 Phillip Lougher 2009-01-05  174  	int offset = squashfs_i(dir)->offset;
5213b0a08263b21 Phillip Lougher 2026-11-11  175  	int err;
5213b0a08263b21 Phillip Lougher 2026-11-11  176  	loff_t length;
52e9ce1c0f20606 Phillip Lougher 2013-09-03  177  	unsigned int dir_count, size;
c88da2c979369e6 Phillip Lougher 2009-01-05  178  
4dddf794b08bef0 Phillip Lougher 2026-11-11  179  	TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(dir)->start, offset);
4dddf794b08bef0 Phillip Lougher 2026-11-11  180  
4dddf794b08bef0 Phillip Lougher 2026-11-11  181  	if (block < 0)
4dddf794b08bef0 Phillip Lougher 2026-11-11  182  		goto data_error;
c88da2c979369e6 Phillip Lougher 2009-01-05  183  
c88da2c979369e6 Phillip Lougher 2009-01-05  184  	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
c88da2c979369e6 Phillip Lougher 2009-01-05  185  	if (dire == NULL) {
c88da2c979369e6 Phillip Lougher 2009-01-05  186  		ERROR("Failed to allocate squashfs_dir_entry\n");
c88da2c979369e6 Phillip Lougher 2009-01-05  187  		return ERR_PTR(-ENOMEM);
c88da2c979369e6 Phillip Lougher 2009-01-05  188  	}
c88da2c979369e6 Phillip Lougher 2009-01-05  189  
c88da2c979369e6 Phillip Lougher 2009-01-05  190  	if (len > SQUASHFS_NAME_LEN) {
c88da2c979369e6 Phillip Lougher 2009-01-05  191  		err = -ENAMETOOLONG;
c88da2c979369e6 Phillip Lougher 2009-01-05  192  		goto failed;
c88da2c979369e6 Phillip Lougher 2009-01-05  193  	}
c88da2c979369e6 Phillip Lougher 2009-01-05  194  
c88da2c979369e6 Phillip Lougher 2009-01-05  195  	length = get_dir_index_using_name(dir->i_sb, &block, &offset,
c88da2c979369e6 Phillip Lougher 2009-01-05  196  				squashfs_i(dir)->dir_idx_start,
c88da2c979369e6 Phillip Lougher 2009-01-05  197  				squashfs_i(dir)->dir_idx_offset,
5213b0a08263b21 Phillip Lougher 2026-11-11  198  				squashfs_i(dir)->dir_idx_cnt,
5213b0a08263b21 Phillip Lougher 2026-11-11  199  				i_size_read(dir), name);
c88da2c979369e6 Phillip Lougher 2009-01-05  200  
c88da2c979369e6 Phillip Lougher 2009-01-05  201  	while (length < i_size_read(dir)) {
c88da2c979369e6 Phillip Lougher 2009-01-05  202  		/*
c88da2c979369e6 Phillip Lougher 2009-01-05  203  		 * Read directory header.
c88da2c979369e6 Phillip Lougher 2009-01-05  204  		 */
5213b0a08263b21 Phillip Lougher 2026-11-11  205  		if (!squashfs_dir_space(dir, length, sizeof(dirh)))
5213b0a08263b21 Phillip Lougher 2026-11-11  206  			goto read_failure;
5213b0a08263b21 Phillip Lougher 2026-11-11  207  
c88da2c979369e6 Phillip Lougher 2009-01-05  208  		err = squashfs_read_metadata(dir->i_sb, &dirh, &block,
c88da2c979369e6 Phillip Lougher 2009-01-05  209  				&offset, sizeof(dirh));
c88da2c979369e6 Phillip Lougher 2009-01-05  210  		if (err < 0)
c88da2c979369e6 Phillip Lougher 2009-01-05  211  			goto read_failure;
c88da2c979369e6 Phillip Lougher 2009-01-05  212  
c88da2c979369e6 Phillip Lougher 2009-01-05  213  		length += sizeof(dirh);
c88da2c979369e6 Phillip Lougher 2009-01-05  214  
c88da2c979369e6 Phillip Lougher 2009-01-05  215  		dir_count = le32_to_cpu(dirh.count) + 1;
44cff8a9ee8a974 Phillip Lougher 2011-03-15  216  
4826d83d9c4f6bb Ajeet Yadav     2012-02-02  217  		if (dir_count > SQUASHFS_DIR_COUNT)
44cff8a9ee8a974 Phillip Lougher 2011-03-15  218  			goto data_error;
44cff8a9ee8a974 Phillip Lougher 2011-03-15  219  
c88da2c979369e6 Phillip Lougher 2009-01-05  220  		while (dir_count--) {
c88da2c979369e6 Phillip Lougher 2009-01-05  221  			/*
c88da2c979369e6 Phillip Lougher 2009-01-05  222  			 * Read directory entry.
c88da2c979369e6 Phillip Lougher 2009-01-05  223  			 */
5213b0a08263b21 Phillip Lougher 2026-11-11  224  			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
5213b0a08263b21 Phillip Lougher 2026-11-11  225  				goto read_failure;

We need an error code on this path.

5213b0a08263b21 Phillip Lougher 2026-11-11  226  
c88da2c979369e6 Phillip Lougher 2009-01-05  227  			err = squashfs_read_metadata(dir->i_sb, dire, &block,
c88da2c979369e6 Phillip Lougher 2009-01-05  228  					&offset, sizeof(*dire));
c88da2c979369e6 Phillip Lougher 2009-01-05  229  			if (err < 0)
c88da2c979369e6 Phillip Lougher 2009-01-05  230  				goto read_failure;
c88da2c979369e6 Phillip Lougher 2009-01-05  231  
5213b0a08263b21 Phillip Lougher 2026-11-11  232  			length += sizeof(*dire);
c88da2c979369e6 Phillip Lougher 2009-01-05  233  			size = le16_to_cpu(dire->size) + 1;
c88da2c979369e6 Phillip Lougher 2009-01-05  234  
44cff8a9ee8a974 Phillip Lougher 2011-03-15  235  			/* size should never be larger than SQUASHFS_NAME_LEN */
44cff8a9ee8a974 Phillip Lougher 2011-03-15  236  			if (size > SQUASHFS_NAME_LEN)
44cff8a9ee8a974 Phillip Lougher 2011-03-15  237  				goto data_error;
44cff8a9ee8a974 Phillip Lougher 2011-03-15  238  
5213b0a08263b21 Phillip Lougher 2026-11-11  239  			if (!squashfs_dir_space(dir, length, size))
5213b0a08263b21 Phillip Lougher 2026-11-11  240  				goto read_failure;

And here.

5213b0a08263b21 Phillip Lougher 2026-11-11  241  
c88da2c979369e6 Phillip Lougher 2009-01-05  242  			err = squashfs_read_metadata(dir->i_sb, dire->name,
c88da2c979369e6 Phillip Lougher 2009-01-05  243  					&block, &offset, size);
c88da2c979369e6 Phillip Lougher 2009-01-05  244  			if (err < 0)
c88da2c979369e6 Phillip Lougher 2009-01-05  245  				goto read_failure;
c88da2c979369e6 Phillip Lougher 2009-01-05  246  
5213b0a08263b21 Phillip Lougher 2026-11-11  247  			length += size;
c88da2c979369e6 Phillip Lougher 2009-01-05  248  
c88da2c979369e6 Phillip Lougher 2009-01-05  249  			if (name[0] < dire->name[0])
c88da2c979369e6 Phillip Lougher 2009-01-05  250  				goto exit_lookup;
c88da2c979369e6 Phillip Lougher 2009-01-05  251  
c88da2c979369e6 Phillip Lougher 2009-01-05  252  			if (len == size && !strncmp(name, dire->name, len)) {
c88da2c979369e6 Phillip Lougher 2009-01-05  253  				unsigned int blk, off, ino_num;
c88da2c979369e6 Phillip Lougher 2009-01-05  254  				long long ino;
c88da2c979369e6 Phillip Lougher 2009-01-05  255  				blk = le32_to_cpu(dirh.start_block);
c88da2c979369e6 Phillip Lougher 2009-01-05  256  				off = le16_to_cpu(dire->offset);
c88da2c979369e6 Phillip Lougher 2009-01-05  257  				ino_num = le32_to_cpu(dirh.inode_number) +
c88da2c979369e6 Phillip Lougher 2009-01-05  258  					(short) le16_to_cpu(dire->inode_number);
cec4a69189091ba Phillip Lougher 2026-11-11  259  				ino = squashfs_mkinode(blk, off);
c88da2c979369e6 Phillip Lougher 2009-01-05  260  
c88da2c979369e6 Phillip Lougher 2009-01-05  261  				TRACE("calling squashfs_iget for directory "
c88da2c979369e6 Phillip Lougher 2009-01-05  262  					"entry %s, inode  %x:%x, %d\n", name,
c88da2c979369e6 Phillip Lougher 2009-01-05  263  					blk, off, ino_num);
c88da2c979369e6 Phillip Lougher 2009-01-05  264  
c88da2c979369e6 Phillip Lougher 2009-01-05  265  				inode = squashfs_iget(dir->i_sb, ino, ino_num);
c88da2c979369e6 Phillip Lougher 2009-01-05  266  				goto exit_lookup;
c88da2c979369e6 Phillip Lougher 2009-01-05  267  			}
c88da2c979369e6 Phillip Lougher 2009-01-05  268  		}
c88da2c979369e6 Phillip Lougher 2009-01-05  269  	}
c88da2c979369e6 Phillip Lougher 2009-01-05  270  
c88da2c979369e6 Phillip Lougher 2009-01-05  271  exit_lookup:
c88da2c979369e6 Phillip Lougher 2009-01-05  272  	kfree(dire);
c88da2c979369e6 Phillip Lougher 2009-01-05  273  	return d_splice_alias(inode, dentry);
c88da2c979369e6 Phillip Lougher 2009-01-05  274  
44cff8a9ee8a974 Phillip Lougher 2011-03-15  275  data_error:
44cff8a9ee8a974 Phillip Lougher 2011-03-15  276  	err = -EIO;
44cff8a9ee8a974 Phillip Lougher 2011-03-15  277  
c88da2c979369e6 Phillip Lougher 2009-01-05  278  read_failure:
c88da2c979369e6 Phillip Lougher 2009-01-05  279  	ERROR("Unable to read directory block [%llx:%x]\n",
4dddf794b08bef0 Phillip Lougher 2026-11-11  280  		squashfs_i(dir)->start, squashfs_i(dir)->offset);
c88da2c979369e6 Phillip Lougher 2009-01-05  281  failed:
c88da2c979369e6 Phillip Lougher 2009-01-05  282  	kfree(dire);
c88da2c979369e6 Phillip Lougher 2009-01-05 @283  	return ERR_PTR(err);
c88da2c979369e6 Phillip Lougher 2009-01-05  284  }

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

