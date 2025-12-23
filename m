Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E6C34B404;
	Tue, 23 Dec 2025 19:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517871; cv=none; b=J1Bmtya32ark2uLrXnKF3eGqwCE/OiPqv5gCKI49bJ4acz58sn6Jdrtfu714Y7HZf4dD3QtZL5xXnwsVAPeMiKoycrb5PL+vz6Gn5EW5Sx7ejcR3fWTE2wu4r3fPvilZJ22X0BFE7ou97Qf0EtP62NKfS9ox7zRKjFCUbbGdst8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517871; c=relaxed/simple;
	bh=kBnYi6edvkpqki1EwKhFzz2Ql7S9JOJI2u3U0xzI3nY=;
	h=Date:To:From:Subject:Message-Id; b=EFIF1MYl9wj7vJCxlFy+v/F5slbKS4PsjrusR96fg2RdCN46xYDkXSzwVsfP24l6UEfPaIw+bT3Krv50d9vRb9OstpPPNUxpeZsN2dDRxodGjHGXm+vTDc242UW+FBxyOj/OzB+W70r1Y2qASWaSVhIZcqOwrUftvl8gcz8c7z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PHiXvE1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PHiXvE1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816D8C113D0;
	Tue, 23 Dec 2025 19:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517870;
	bh=kBnYi6edvkpqki1EwKhFzz2Ql7S9JOJI2u3U0xzI3nY=;
	h=Date:To:From:Subject:From;
	b=PHiXvE1qfWscIVpKxKxkAQnhSg1zkrGs+blgchofLDCSZcFaNHENCZG1VE8uEfOrJ
	 nHExi11gpbjfSYXOJVf2KYkkdw3VPu9ZjAX/TQ4kc0uWxIpjav/1AQCyVqgM7RM8sZ
	 xkIDJNnHbWxteeRGRsObFtNOexxqJkIhgbYx4iE0=
Date: Tue, 23 Dec 2025 11:24:29 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,elver@google.com,andreyknvl@gmail.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_owner-fix-memory-leak-in-page_owner_stack_fops-release.patch removed from -mm tree
Message-Id: <20251223192430.816D8C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: fix memory leak in page_owner_stack_fops->release()
has been removed from the -mm tree.  Its filename was
     mm-page_owner-fix-memory-leak-in-page_owner_stack_fops-release.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: mm/page_owner: fix memory leak in page_owner_stack_fops->release()
Date: Fri, 19 Dec 2025 07:42:32 +0000

The page_owner_stack_fops->open() callback invokes seq_open_private(),
therefore its corresponding ->release() callback must call
seq_release_private().  Otherwise it will cause a memory leak of struct
stack_print_ctx.

Link: https://lkml.kernel.org/r/20251219074232.136482-1-ranxiaokai627@163.com
Fixes: 765973a09803 ("mm,page_owner: display all stacks and their count")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marco Elver <elver@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-fix-memory-leak-in-page_owner_stack_fops-release
+++ a/mm/page_owner.c
@@ -952,7 +952,7 @@ static const struct file_operations page
 	.open		= page_owner_stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_private,
 };
 
 static int page_owner_threshold_get(void *data, u64 *val)
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are


