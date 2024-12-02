Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E195B1F8F06
	for <mm-commits@vger.kernel.org>; Mon,  2 Dec 2024 06:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733119601; cv=none; b=uUciV+GxTvrUG41j4YX5orLhyV/uZRtMYwKu4O6XYfxucXjsGDy/0ufjlLycd7YD5s+ASbfvsDfodmZ/jSZuI50a6EpgTrkwY2Hp0OkJxyhql3AiOwsOfQFhA0z7I6ksyb2N4OT2wqTEeLBY+vIczvCOvVpztmTvGqSCFATfz5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733119601; c=relaxed/simple;
	bh=FiIJLMkSqsXvs93a+lUiMPHEB1srzz+icZZkjjPLm34=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=evRVy5trIBfOHPmgXJFjH27vYS55DEdRdIW/y6iIzY7ZHD6lnASZlocwbOnf9ADNpXrcPVgmdhSJbbkNgiIgTdz8M7dr8us6JJKModxbz88phf9J8yRHbpaE7xunP6uhJjBJo8uo5C4tLCVZTCjyVVghUVhjmJN035YuErhZKtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lr4cqVvq; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lr4cqVvq"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7eab7600800so432326a12.1
        for <mm-commits@vger.kernel.org>; Sun, 01 Dec 2024 22:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733119599; x=1733724399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+0CCZFICpNtfbIYKd1rZY7z2SVCxK3MxNoOTM/+bnC8=;
        b=Lr4cqVvqOhzRfSirX+pacK2W5pG7XydpquMvz7osmAdVhCzdn3htWGiDfGyUeERPG/
         w8RE91A3qXsoE6KOpTyd5/BBwq6WDW4Q8pJaKh8S5w4d6KsDrLNG8MM1pBD8heZnHILU
         xuCGOldOnAx/DGrU/uJqFK1nd/j61TbhNGIFrmd5yYLjctxJb1kgBdV9ldq0d4RfOmqG
         j6rLR8X8wFXr7mrMFJLYADSelR+IH8YGfhVpZTt0V+5dMzFerKsDGAsE18HdO0FabRu6
         On0csJfT/pgKQqqjjhZBkQf4WCY5ug+8D3XGaZt8iBj+KMUgxkX8QG6yQJ6FX/Rr+41F
         pbCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733119599; x=1733724399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+0CCZFICpNtfbIYKd1rZY7z2SVCxK3MxNoOTM/+bnC8=;
        b=DZmsVW8YyxFlsACWFKhcfQXqfTVIHMQoB0Tao1SU4LvNJ9W7dE13oEDvWoFllKrcj+
         WU/LJOQA5JAEhdvkGMdPwb8uwjVH8iP+otVAoMIvemTQ7GdOMc8phAtbda3htoBunNXD
         5hbK8j7Z1TfR/9bshiBaguhbpHmxTcoaIPsfxCxGUIby8amCmfybkDzr8XX1wF37hSGs
         rzcU1LjWxxJrIXM2Cgy+yPdXGRg2KhuwnzoZ4oazW/OUOeLM06Rou5vyuUKdrpfMi07D
         aLrX0TDjgbY2cpQchk+ZBGPsCQnHrNHrrEIRCT8/JjbxrpjgQFfRsuFOdl3ly/HqFaW0
         X0+A==
X-Forwarded-Encrypted: i=1; AJvYcCWyRXDYrtbQkpHnTrronvDnYLnmShrRCADcX7/R70zgjfNBgNhyqZ7g8BuxM3b2ml5ffaYX1MEFzAJk@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6fscmaZ3Rkn0dhB7daoU1AZPrxgqKMDiR23DEMOSprJue/Ws0
	f83FG63vJxRI301y25X/XcntWJl1wxMPhUnWBotyTsQGo+l++QW1
X-Gm-Gg: ASbGncuhGUJ8hXt+dK0nj1TRxdP0Ih1LDiwhhHoKh4HIStQ/3m2qrwcX+VpQbzbxy9z
	x5YD77gZt0u9sslPMpPy3AWv3ys8CKwHWyoU9eHPH3oe0ApKPy+ZIPhfWlkjShHdMByi9Mb4zMw
	8VXEEPRiJOj7UywpmYSWdhuyxyPKbPdmaoMC5Eg2hE+7I+3cxYxgj1jDsfNL5qBrQu73iPUlmGz
	jXS2lf2nnEtl3uGAWTo2Lod9bO12Y8vTao+eek9EmnqQnkJLo/7Qg==
X-Google-Smtp-Source: AGHT+IF2wU+c2L/xQwVG3E5gz4HfkPyFVL1JfKuQ/sOQuo6ALuwdCY9yDAeQKG4OqcOY+7a3rlPapw==
X-Received: by 2002:a17:902:d413:b0:215:3862:603a with SMTP id d9443c01a7336-21538626700mr75669335ad.10.1733119599189;
        Sun, 01 Dec 2024 22:06:39 -0800 (PST)
Received: from x1k.com ([175.42.19.220])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215411c3519sm51465595ad.91.2024.12.01.22.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2024 22:06:38 -0800 (PST)
From: caiqingfu <baicaiaichibaicai@gmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	baicaiaichibaicai@gmail.com,
	caiqingfu@ruijie.com.cn,
	minchan@kernel.org,
	mm-commits@vger.kernel.org
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Date: Mon,  2 Dec 2024 14:06:32 +0800
Message-Id: <20241202060632.139067-1-baicaiaichibaicai@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241130053247.GH10431@google.com>
References: <20241130053247.GH10431@google.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I honestly don't know...
> 
> What is changing the page under write()?  If something is modifying
> page's content in parallel with zram's write() then you can't really
> use zram, if the content is changing concurrently with zram's compression
> then I really don't see how it would be able to decompress it later
> and what would it decompress to (some mix of stale and new data?).

I am not familiar with file systems and lzro, so I dumped the page owner of the modified page. 
The function stack of most page allocated is as follows:

[   46.560092] page_owner tracks the page as allocated
[   46.560101] page last allocated via order 0, migratetype Movable, gfp_mask 0x148c48(GFP_NOFS|__GFP_NOFAIL|__GFP_COMP|__GFP_HARDWALL|__GFP_MOVABLE), pid 1769, tgid 1372 (a.out), ts 45588110160, free_ts 45123127760
[   46.560126]  prep_new_page+0xa8/0x10c
[   46.560143]  get_page_from_freelist+0xa44/0x16d0
[   46.560160]  __alloc_pages_noprof+0x150/0x290
[   46.560177]  alloc_pages_mpol_noprof+0x88/0x23c
[   46.560195]  alloc_pages_noprof+0x4c/0x7c
[   46.560234]  folio_alloc_noprof+0x14/0x64
[   46.560254]  filemap_alloc_folio_noprof+0x100/0x14c
[   46.560272]  __filemap_get_folio+0x21c/0x38c
[   46.560290]  bdev_getblk+0xd0/0x2b4
[   46.560304]  __ext4_get_inode_loc+0x11c/0x53c
[   46.560320]  ext4_get_inode_loc+0x44/0xb0
[   46.560337]  ext4_reserve_inode_write+0x40/0xf0
[   46.560354]  __ext4_mark_inode_dirty+0x4c/0x1f0
[   46.560370]  ext4_ext_tree_init+0x40/0x4c
[   46.560388]  __ext4_new_inode+0x790/0x13b8
[   46.560406]  ext4_create+0xdc/0x1d0

and other list this:

[   47.683962] page_owner tracks the page as allocated
[   47.684012] page last allocated via order 0, migratetype Unmovable, gfp_mask 0x148c40(GFP_NOFS|__GFP_NOFAIL|__GFP_COMP|__GFP_HARDWALL), pid 1309, tgid 970 (a.out), ts 44091572544, free_ts 0
[   47.684056]  prep_new_page+0xa8/0x10c
[   47.684090]  get_page_from_freelist+0xa44/0x16d0
[   47.684109]  __alloc_pages_noprof+0x150/0x290
[   47.684127]  alloc_pages_mpol_noprof+0x88/0x23c
[   47.684148]  alloc_pages_noprof+0x4c/0x7c
[   47.684166]  folio_alloc_noprof+0x14/0x64
[   47.684184]  filemap_alloc_folio_noprof+0x100/0x14c
[   47.684205]  __filemap_get_folio+0x21c/0x38c
[   47.684223]  bdev_getblk+0xd0/0x2b4
[   47.684240]  ext4_getblk+0xac/0x300
[   47.684258]  ext4_bread+0x14/0xe4
[   47.684274]  ext4_append+0x90/0x1cc
[   47.684293]  do_split+0x88/0x9c4
[   47.684307]  make_indexed_dir+0x580/0x688
[   47.684322]  ext4_add_entry+0x37c/0x420
[   47.684337]  ext4_add_nondir+0x38/0x11c

It look like only the file system metadata has been modified.I'm not sure.
