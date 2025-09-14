Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9316018B0F;
	Sun, 14 Sep 2025 00:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757808924; cv=none; b=QGongc3rMmmyB5D5hbCeJPqP/iQek9k8BmXTq2cmo6fG3XdD6yc+y26y4ytthZpji6KBfvfnAHYpQQwX/u04pjzzO25qb2PeLau3+/wzqjgjdMxTc/PLytdYJ2df1ao9BtHkNbFctaPLpTv88X5mBG5B0Q2FFfqYKx+JDIx9j1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757808924; c=relaxed/simple;
	bh=rekzWScgw/RCtbuC/N7Wd78LY3vCXYc5AIruzbTQZgQ=;
	h=Date:To:From:Subject:Message-Id; b=ow7W92kajFZAHrm2XkdACHLu5X7Ywn6M9ELgaFooTt3AW2xkOSWLQ7Qp+YGUwg0LtRiyivfm/ImFWpyuFv4+hOCiUG1ajlQY+QDHGj1X+/NhkEteHjowOhk/DtzKsYdJOzBc62Rk15nSLG4km8nmBcV0z7EAVkWxXNdrRpJlS0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XYX+0E+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XYX+0E+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C759C4CEEB;
	Sun, 14 Sep 2025 00:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757808924;
	bh=rekzWScgw/RCtbuC/N7Wd78LY3vCXYc5AIruzbTQZgQ=;
	h=Date:To:From:Subject:From;
	b=XYX+0E+w9XLg+FXWVGCpGlOG115AU0vjA87Yk1gk0oaTXAbsCfBK6reDuQPMPlfns
	 L/kDqmftA907+DthNls3WxwPNeqHOYefc7+soOuZesG9tjaFx8Bkvv8Uj5tlGnYXKN
	 +6zu1KsrARCp3GzYy0F8nNhX+84iMqfQDTIHJi54=
Date: Sat, 13 Sep 2025 17:15:23 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,jack@suse.cz,brauner@kernel.org,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] init-handle-bootloader-identifier-in-kernel-parameters-v4.patch removed from -mm tree
Message-Id: <20250914001524.1C759C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init-handle-bootloader-identifier-in-kernel-parameters-v4
has been removed from the -mm tree.  Its filename was
     init-handle-bootloader-identifier-in-kernel-parameters-v4.patch

This patch was dropped because it was folded into init-handle-bootloader-identifier-in-kernel-parameters.patch

------------------------------------------------------
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: init-handle-bootloader-identifier-in-kernel-parameters-v4
Date: Fri, 15 Aug 2025 17:01:20 +0800

use strstarts()

Link: https://lkml.kernel.org/r/20250815090120.1569947-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-handle-bootloader-identifier-in-kernel-parameters-v4
+++ a/init/main.c
@@ -559,7 +559,7 @@ static int __init unknown_bootoption(cha
 
 	/* Handle bootloader identifier */
 	for (int i = 0; bootloader[i]; i++) {
-		if (!strncmp(param, bootloader[i], strlen(bootloader[i])))
+		if (strstarts(param, bootloader[i]))
 			return 0;
 	}
 
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are

init-handle-bootloader-identifier-in-kernel-parameters.patch

