Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C299C2B9A9
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 22:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747866920; cv=none; b=q5skQ27/zKoLWgycVLxB07Wj7sNjXsMKoSyq9DPZv/VK+LmgiJ3p2/wrmcf97KMNj9NZFtX/g5WDjznqtrY7K/GGSTLPxtev6DONynJICJbefZ331497aNASreQNoWZ39b84ujW3eupI9durKxWTgNDlcA51hmfkDO42Nxy3Hyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747866920; c=relaxed/simple;
	bh=hWbqp7Bw3HC03OpUH0JbNbO8rmA23GphO7U2TEMGFQ0=;
	h=Date:To:From:Subject:Message-Id; b=UgW1HIuYbBvSA9aBlnkJCXa3/aLqU6pAYGzAho1RscdHi/ckTc+XKiDF7D68oFwcIpvMxaEkV6ljT/NBN+b5l8VT47iAT4wkUYpqqmxSox2b/P5Mxzr6ihkGQgIoxekwZB09NItaMG8fEVPqQYvcQ8qOEv7fZU5F1DTIo0IuxQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u5NNGa1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u5NNGa1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A08C4CEE4;
	Wed, 21 May 2025 22:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747866920;
	bh=hWbqp7Bw3HC03OpUH0JbNbO8rmA23GphO7U2TEMGFQ0=;
	h=Date:To:From:Subject:From;
	b=u5NNGa1mon+z18rYXYvPbEZmgvNHWIQsT26maHkg5OtwAxmVA0RV5CKs0l+YVKjZ8
	 qLbGwTvwMFuzeCoJpfsbsHSyU4rCexpNbBXo03jCQqkAWeOIG/BhESWAXii/Bj6fVj
	 dgB8HVRROL8Yz5FsVSfPI/AFpcfe1JDvE/JbKs4o=
Date: Wed, 21 May 2025 15:35:19 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,jiang.kun2@zte.com.cn,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + delayacct-remove-redundant-code-and-adjust-indentation.patch added to mm-nonmm-unstable branch
Message-Id: <20250521223520.34A08C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: delayacct: remove redundant code and adjust indentation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     delayacct-remove-redundant-code-and-adjust-indentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delayacct-remove-redundant-code-and-adjust-indentation.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: delayacct: remove redundant code and adjust indentation
Date: Wed, 21 May 2025 09:31:57 +0800 (CST)

Remove redundant code and adjust indentation of xxx_delay_max/min.

Link: https://lkml.kernel.org/r/20250521093157668iQrhhcMjA-th5LQf4-A3c@zte.com.cn
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/delayacct.c |   51 +++++++++++++------------------------------
 1 file changed, 16 insertions(+), 35 deletions(-)

--- a/kernel/delayacct.c~delayacct-remove-redundant-code-and-adjust-indentation
+++ a/kernel/delayacct.c
@@ -14,6 +14,15 @@
 #include <linux/delayacct.h>
 #include <linux/module.h>
 
+#define UPDATE_DELAY(type) \
+do { \
+	d->type##_delay_max = tsk->delays->type##_delay_max; \
+	d->type##_delay_min = tsk->delays->type##_delay_min; \
+	tmp = d->type##_delay_total + tsk->delays->type##_delay; \
+	d->type##_delay_total = (tmp < d->type##_delay_total) ? 0 : tmp; \
+	d->type##_count += tsk->delays->type##_count; \
+} while (0)
+
 DEFINE_STATIC_KEY_FALSE(delayacct_key);
 int delayacct_on __read_mostly;	/* Delay accounting turned on/off */
 struct kmem_cache *delayacct_cache;
@@ -173,41 +182,13 @@ int delayacct_add_tsk(struct taskstats *
 
 	/* zero XXX_total, non-zero XXX_count implies XXX stat overflowed */
 	raw_spin_lock_irqsave(&tsk->delays->lock, flags);
-	d->blkio_delay_max = tsk->delays->blkio_delay_max;
-	d->blkio_delay_min = tsk->delays->blkio_delay_min;
-	tmp = d->blkio_delay_total + tsk->delays->blkio_delay;
-	d->blkio_delay_total = (tmp < d->blkio_delay_total) ? 0 : tmp;
-	d->swapin_delay_max = tsk->delays->swapin_delay_max;
-	d->swapin_delay_min = tsk->delays->swapin_delay_min;
-	tmp = d->swapin_delay_total + tsk->delays->swapin_delay;
-	d->swapin_delay_total = (tmp < d->swapin_delay_total) ? 0 : tmp;
-	d->freepages_delay_max = tsk->delays->freepages_delay_max;
-	d->freepages_delay_min = tsk->delays->freepages_delay_min;
-	tmp = d->freepages_delay_total + tsk->delays->freepages_delay;
-	d->freepages_delay_total = (tmp < d->freepages_delay_total) ? 0 : tmp;
-	d->thrashing_delay_max = tsk->delays->thrashing_delay_max;
-	d->thrashing_delay_min = tsk->delays->thrashing_delay_min;
-	tmp = d->thrashing_delay_total + tsk->delays->thrashing_delay;
-	d->thrashing_delay_total = (tmp < d->thrashing_delay_total) ? 0 : tmp;
-	d->compact_delay_max = tsk->delays->compact_delay_max;
-	d->compact_delay_min = tsk->delays->compact_delay_min;
-	tmp = d->compact_delay_total + tsk->delays->compact_delay;
-	d->compact_delay_total = (tmp < d->compact_delay_total) ? 0 : tmp;
-	d->wpcopy_delay_max = tsk->delays->wpcopy_delay_max;
-	d->wpcopy_delay_min = tsk->delays->wpcopy_delay_min;
-	tmp = d->wpcopy_delay_total + tsk->delays->wpcopy_delay;
-	d->wpcopy_delay_total = (tmp < d->wpcopy_delay_total) ? 0 : tmp;
-	d->irq_delay_max = tsk->delays->irq_delay_max;
-	d->irq_delay_min = tsk->delays->irq_delay_min;
-	tmp = d->irq_delay_total + tsk->delays->irq_delay;
-	d->irq_delay_total = (tmp < d->irq_delay_total) ? 0 : tmp;
-	d->blkio_count += tsk->delays->blkio_count;
-	d->swapin_count += tsk->delays->swapin_count;
-	d->freepages_count += tsk->delays->freepages_count;
-	d->thrashing_count += tsk->delays->thrashing_count;
-	d->compact_count += tsk->delays->compact_count;
-	d->wpcopy_count += tsk->delays->wpcopy_count;
-	d->irq_count += tsk->delays->irq_count;
+	UPDATE_DELAY(blkio);
+	UPDATE_DELAY(swapin);
+	UPDATE_DELAY(freepages);
+	UPDATE_DELAY(thrashing);
+	UPDATE_DELAY(compact);
+	UPDATE_DELAY(wpcopy);
+	UPDATE_DELAY(irq);
 	raw_spin_unlock_irqrestore(&tsk->delays->lock, flags);
 
 	return 0;
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

delayacct-remove-redundant-code-and-adjust-indentation.patch

