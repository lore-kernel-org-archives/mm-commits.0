Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D9A15E5BB
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313712; cv=none; b=YMOOBqQjP+RZmgCeDeYEMCbqCkWk1qYVbN1FJj1CGxLpESF8xHdao8As7ZvIVyaMvi3KbSxz7vx3vKyeQCzHn6lE8Vqj92hySPE4f4TbZVGrlymZmw8dCY84F9eJly0Wa0lqGfk1MStPjuv4PyPH3oHbhsLyDOmwrSP1F9CJl2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313712; c=relaxed/simple;
	bh=8zmKGUCLvoTaCok5of41c+hizrzzUUg4YNPARc/BYNg=;
	h=Date:To:From:Subject:Message-Id; b=O5IxzaHfKQI4n5/TrK36xMNvM4sZqalZuk1OZCgusEaIcZXw79pk7ex96IF6O/kL4zJ2Kp3wIvmI+n7giC4Cso8twxj5HLMZfEOJItb+RtA6HwEVIOArarS1oNLCvS0ocqlQhUgIqa3VROL8LxNPvnMlVZjLbaBAzQlFLRpxNiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vYSFV77s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vYSFV77s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5C6C4CED0;
	Mon, 11 Nov 2024 08:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313711;
	bh=8zmKGUCLvoTaCok5of41c+hizrzzUUg4YNPARc/BYNg=;
	h=Date:To:From:Subject:From;
	b=vYSFV77sTKTwCjM0WCDSrJHbHw7O6NzynUxCXvM4MrVAOO2Lrj81GvyEfFQFpjTww
	 0P75hAvhwvldnc8l5d9xAPVZktkiTm36GpwNtmmbVXrk5f5dGQ75gLJGYMj8kskxrD
	 kq7xg+3sp5z4tToPjD3FE0tP5NS0+WfXKzJPOw6c=
Date: Mon, 11 Nov 2024 00:28:31 -0800
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-replace-sprintf-with-sysfs_emit.patch removed from -mm tree
Message-Id: <20241111082831.AD5C6C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: replace sprintf() with sysfs_emit()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-replace-sprintf-with-sysfs_emit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhangguopeng <zhangguopeng@kylinos.cn>
Subject: mm/memory-failure: replace sprintf() with sysfs_emit()
Date: Tue, 29 Oct 2024 18:18:53 +0800

As Documentation/filesystems/sysfs.rst suggested, show() should only use
sysfs_emit() or sysfs_emit_at() when formatting the value to be returned
to user space.

Link: https://lkml.kernel.org/r/20241029101853.37890-1-zhangguopeng@kylinos.cn
Signed-off-by: zhangguopeng <zhangguopeng@kylinos.cn>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-replace-sprintf-with-sysfs_emit
+++ a/mm/memory-failure.c
@@ -100,7 +100,7 @@ static ssize_t _name##_show(struct devic
 {								\
 	struct memory_failure_stats *mf_stats =			\
 		&NODE_DATA(dev->id)->mf_stats;			\
-	return sprintf(buf, "%lu\n", mf_stats->_name);		\
+	return sysfs_emit(buf, "%lu\n", mf_stats->_name);	\
 }								\
 static DEVICE_ATTR_RO(_name)
 
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

kernel-reboot-replace-sprintf-with-sysfs_emit.patch

