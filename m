Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757B8D53F
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 19:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730230364; cv=none; b=VkJU6jtNDMTUsC4EPT7lFIPrdD+lNGJtqYPw0LI4AxuPt+m2iTG9QVXRAIdkUWyExKJHWRb4k/1jihbwf47ywffaMHketqXfpvWGezFItrjuLC32sXYJ6hYTIMKNIFXzXCygqtV1PqIjQ/advP17bWp9L3t1lYDzlgHMvmFr3kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730230364; c=relaxed/simple;
	bh=1vCJWtLy7QdqIxrwsTZhqoWtXKygbHcysdSyOrZUzdo=;
	h=Date:To:From:Subject:Message-Id; b=s++Rt+nBPsJFbvm9czf4FfL5BTMN3pToKulqcmv3uKRT+teG+0xwTCWiYTNatmwBDYZygoDmJbD0s4E9/g7nTFqUrN3Qdr7mCfmEQA0cZA3Lp2JdZ+f6MQHneeFnqIiaIAZGGWYGVElhws9rbiLvlRILLx3GhkPXerY+Jq+bB5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n1hfWrqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n1hfWrqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E867CC4CECD;
	Tue, 29 Oct 2024 19:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730230364;
	bh=1vCJWtLy7QdqIxrwsTZhqoWtXKygbHcysdSyOrZUzdo=;
	h=Date:To:From:Subject:From;
	b=n1hfWrqMEodbE/ufRSfJt0yBU+OrbQWgAWVJGmX1E6Vz7DK0bQnvt4ps4JsJDBPDE
	 9H9gM0Yi8M4aaB2PzlJnQSkzSdMkPGf5NY7v0RAcGvjOL8exNPdKWkgh8Rx17batZS
	 wmcVUT+s7j/pmc2CkbHkt3YOWTZtuxbV7tteC7TI=
Date: Tue, 29 Oct 2024 12:32:42 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-replace-sprintf-with-sysfs_emit.patch added to mm-unstable branch
Message-Id: <20241029193243.E867CC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: replace sprintf() with sysfs_emit()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-replace-sprintf-with-sysfs_emit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-replace-sprintf-with-sysfs_emit.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: zhangguopeng <zhangguopeng@kylinos.cn>
Subject: mm/memory-failure: replace sprintf() with sysfs_emit()
Date: Tue, 29 Oct 2024 18:18:53 +0800

As Documentation/filesystems/sysfs.rst suggested, show() should only use
sysfs_emit() or sysfs_emit_at() when formatting the value to be returned
to user space.

Link: https://lkml.kernel.org/r/20241029101853.37890-1-zhangguopeng@kylinos.cn
Signed-off-by: zhangguopeng <zhangguopeng@kylinos.cn>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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

mm-memory-failure-replace-sprintf-with-sysfs_emit.patch

