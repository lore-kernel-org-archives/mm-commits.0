Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C27FC0B;
	Tue, 31 Dec 2024 01:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610395; cv=none; b=nKvu7MwNgPSTuXBKP70sDvOU2c1V4bWrr68X1Kd2nozVZp3196hPlPp09UKcZJ/7vC86qt5/X3s0OSmhCWPOtcG1L0SgYEBL+/11rzeKY0zpyKF3zp+Cb6uudkhP/GhC2/zNo/JLcQCJDLbnCsyDWR+KnGS+ZjxH+bRHDRx3CIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610395; c=relaxed/simple;
	bh=LiIYiVq8OpASnSwSChrgafAH3YQ11gBpHeN70P0k9lQ=;
	h=Date:To:From:Subject:Message-Id; b=eUCb0zixvV23jrwZ9qnM5VDtOyvSWT0DCgLhotrBjUQFIYQ30ZN9vREMwzh8JnLdoSCLfS5aYXRdbcQLn3fJPO/rgpyjst0JqnsFdtqXeylWouL5YABnfXenKkmOtjjcghV7FW9eZtYrVp17/iziL87jzk1dgJvDo2jDSY+V654=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AklQrdDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AklQrdDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB37DC4CED0;
	Tue, 31 Dec 2024 01:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610394;
	bh=LiIYiVq8OpASnSwSChrgafAH3YQ11gBpHeN70P0k9lQ=;
	h=Date:To:From:Subject:From;
	b=AklQrdDa5G5OPFKDLUu8khjbHYZfPWykBUjMbNZoF3Q0hDvJzADt9Nwti2ifnROG7
	 gh5dDOH4Z3lx19YPKh/kkfX9ySawEGHvtsfMIJbcu/wzKNw+kX4vvlCXEqq6t8npXx
	 sDHolb4HfET+99EZfJtyg6LYqw6oxJt8gQopYTcw=
Date: Mon, 30 Dec 2024 17:59:54 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,Liam.Howlett@Oracle.com,chuck.lever@oracle.com,brauner@kernel.org,yangerkun@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-reload-mas-before-the-second-call-for-mas_empty_area.patch removed from -mm tree
Message-Id: <20241231015954.CB37DC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: reload mas before the second call for mas_empty_area
has been removed from the -mm tree.  Its filename was
     maple_tree-reload-mas-before-the-second-call-for-mas_empty_area.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Erkun <yangerkun@huawei.com>
Subject: maple_tree: reload mas before the second call for mas_empty_area
Date: Sat, 14 Dec 2024 17:30:05 +0800

Change the LONG_MAX in simple_offset_add to 1024, and do latter:

[root@fedora ~]# mkdir /tmp/dir
[root@fedora ~]# for i in {1..1024}; do touch /tmp/dir/$i; done
touch: cannot touch '/tmp/dir/1024': Device or resource busy
[root@fedora ~]# rm /tmp/dir/123
[root@fedora ~]# touch /tmp/dir/1024
[root@fedora ~]# rm /tmp/dir/100
[root@fedora ~]# touch /tmp/dir/1025
touch: cannot touch '/tmp/dir/1025': Device or resource busy

After we delete file 100, actually this is a empty entry, but the latter
create failed unexpected.

mas_alloc_cyclic has two chance to find empty entry.  First find the entry
with range range_lo and range_hi, if no empty entry exist, and range_lo >
min, retry find with range min and range_hi.  However, the first call
mas_empty_area may mark mas as EBUSY, and the second call for
mas_empty_area will return false directly.  Fix this by reload mas before
second call for mas_empty_area.

[Liam.Howlett@Oracle.com: fix mas_alloc_cyclic() second search]
  Link: https://lore.kernel.org/all/20241216060600.287B4C4CED0@smtp.kernel.org/
  Link: https://lkml.kernel.org/r/20241216190113.1226145-2-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20241214093005.72284-1-yangerkun@huaweicloud.com
Fixes: 9b6713cc7522 ("maple_tree: Add mtree_alloc_cyclic()")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com> says:
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/maple_tree.c~maple_tree-reload-mas-before-the-second-call-for-mas_empty_area
+++ a/lib/maple_tree.c
@@ -4354,6 +4354,7 @@ int mas_alloc_cyclic(struct ma_state *ma
 		ret = 1;
 	}
 	if (ret < 0 && range_lo > min) {
+		mas_reset(mas);
 		ret = mas_empty_area(mas, min, range_hi, 1);
 		if (ret == 0)
 			ret = 1;
_

Patches currently in -mm which might be from yangerkun@huawei.com are


