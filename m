Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9D4145347
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293206; cv=none; b=W8olr+pYxu4CqC4b7N5vsSGhCVODKNsCewLk2jI/9Jh1fiTmWRdBZlVMJZBQGZ2xnrJAs7lx/fcetWi8k3Nrr2JzXgIxhUpmetTNwwgSZBH+ja6Pw4HlfxWvSgWPmgdj4zmK8fakpwjED5M/Pv6eNp5IqIRMwNntGdvUyR08IJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293206; c=relaxed/simple;
	bh=0o5rc3ZgBthfx2LnOcC3oX560URL49TG+HFsvDeQqJ8=;
	h=Date:To:From:Subject:Message-Id; b=aStXWmyHe5Z7kKSANhUCAIwOk4xEibf4eIvMF5zm/6oGcRCp62kwKy5hcTIz6Jr7Mj+xahfG8TC3TF6exPCgCcyauhVI1oZBF7sJgHkE+sOdveIrdXwKzWhMfjflPGkUatZed76x+Par5tdRYu805QGj9LVAid77jMrCXY2VkeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nTVfKu/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nTVfKu/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4313EC32782;
	Tue, 25 Jun 2024 05:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293206;
	bh=0o5rc3ZgBthfx2LnOcC3oX560URL49TG+HFsvDeQqJ8=;
	h=Date:To:From:Subject:From;
	b=nTVfKu/66uG7gCmRems1ZAJW/DwR5iw46jSyQUeKAA1PJO9udkL1AE8PJgeMlgV2D
	 Oaj0lI6ILz5mSHC46vQS3vPvFXiTVbVGcIRauf6bKktgZznAE2Odq3WCZmmbBuxoxF
	 2m5t14Cwn6c7jbwgr2KLRDcrM1Kt+qTZ+L7q1nWE=
Date: Mon, 24 Jun 2024 22:26:45 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] uuid-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240625052646.4313EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uuid: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     uuid-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: uuid: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 19:19:09 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_uuid.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-test_uuid-v1-1-67fa498104c0@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_uuid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_uuid.c~uuid-add-missing-module_description-macro
+++ a/lib/test_uuid.c
@@ -130,4 +130,5 @@ static void __exit test_uuid_exit(void)
 module_exit(test_uuid_exit);
 
 MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
+MODULE_DESCRIPTION("Test cases for lib/uuid.c module");
 MODULE_LICENSE("Dual BSD/GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

