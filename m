Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A417818C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628621; cv=none; b=URqMewrjkNK2uJkafEzzmWFTqE9qkVpRuOmSSnBTqWV52rsQiXdavMZbFd8pOpw9gGN4nmP1wwOVSU11d32iJSCjBBAI5gTLcAci1/klnlwvP52TDlWZzEI/1XIVKy+DksDI9sdo9PLNOsuzoVH+PqGXp+eYjjSdjZfEWXb+kR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628621; c=relaxed/simple;
	bh=AAXvVUuZ62I/1EB5LbXjjL0+OYzWwLDwleOnG0LwYdY=;
	h=Date:To:From:Subject:Message-Id; b=OyYV76BoZ6VXHhw3Bge4GoTc7BAqLgLtDXxbB60p5zvgR3zukT33Sk4gSCb5zJAnd+M3nG/xCbTk7COn7MSdgqa9P4jKnjcF8QhgiGVJaxWkbpIiRxefU1eK+E9Lv7QZzEIeQqQOKIG9A75n56AJGriGet2K52BEzWSrqEjPrhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hDdHiWXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hDdHiWXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FF6C116B1;
	Sat, 29 Jun 2024 02:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628621;
	bh=AAXvVUuZ62I/1EB5LbXjjL0+OYzWwLDwleOnG0LwYdY=;
	h=Date:To:From:Subject:From;
	b=hDdHiWXhy1OpV9CvP42FTsrxBQf/F2Dmji1F6BUL/okM2TraS8Kvx1fRLtM87L1Ar
	 oqBjjTgqTwbhKDitSCYZLMc8KdaVRfLAKdwtPxd4CDsLEY8UkiD+w0Qg8EfjXAtuQr
	 qmhGHKXU22EiQV5CENPonVznjF1QOKDQ2A6kd7Ks=
Date: Fri, 28 Jun 2024 19:37:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,quic_jjohnson@quicinc.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-testing-radix-tree-idr-test-add-missing-module_description-define.patch removed from -mm tree
Message-Id: <20240629023701.35FF6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/radix-tree/idr-test: add missing MODULE_DESCRIPTION define
has been removed from the -mm tree.  Its filename was
     tools-testing-radix-tree-idr-test-add-missing-module_description-define.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: tools/testing/radix-tree/idr-test: add missing MODULE_DESCRIPTION define
Date: Wed, 26 Jun 2024 16:21:00 -0700

Userspace builds of the radix-tree testing suite fails because of patch
KUnit: add missing MODULE_DESCRIPTION() macros for lib/test_*.ko.  Add the
proper defines to tools/testing/radix-tree/idr-test.c so
MODULE_DESCRIPTION has a definition.  This allows the build to succeed.

Link: https://lkml.kernel.org/r/20240626232100.306130-1-sidhartha.kumar@oracle.com
Fixes: f069e33dafe1 ("KUnit: add missing MODULE_DESCRIPTION() macros for lib/test_*.ko")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/idr-test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/radix-tree/idr-test.c~tools-testing-radix-tree-idr-test-add-missing-module_description-define
+++ a/tools/testing/radix-tree/idr-test.c
@@ -424,6 +424,7 @@ void idr_checks(void)
 #define module_init(x)
 #define module_exit(x)
 #define MODULE_AUTHOR(x)
+#define MODULE_DESCRIPTION(X)
 #define MODULE_LICENSE(x)
 #define dump_stack()    assert(0)
 void ida_dump(struct ida *);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


