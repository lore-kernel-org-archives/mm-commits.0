Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A0513FE1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bQSlBoSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C11C433C9;
	Fri, 29 Dec 2023 20:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881400;
	bh=GxI1XkoJkGG7cXhKMMGGiMP96w6M0pG/oTI6wDSc12E=;
	h=Date:To:From:Subject:From;
	b=bQSlBoSdt02c3Na5pjOokfX7Vvq+eSAEYannWKDLKaGv0iYJVVYdExzVdB3I2WB4o
	 Sr4CUoQ1MWgPKVpq+gyI0c8igHJSKIG0wJfR7UkV7j/BZQJs0BWps/3JM3lv0LDObj
	 BD0U7/v3eyWgSD9FFBjbpt8L2fsvv1mVxgJPRrHk=
Date: Fri, 29 Dec 2023 12:23:19 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-checkstackpl-change-min_stack-to-512-by-default.patch removed from -mm tree
Message-Id: <20231229202320.74C11C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/checkstack.pl: change min_stack to 512 by default
has been removed from the -mm tree.  Its filename was
     scripts-checkstackpl-change-min_stack-to-512-by-default.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: scripts/checkstack.pl: change min_stack to 512 by default
Date: Tue, 19 Dec 2023 20:50:00 +0800

According to Documentation/process/submit-checklist.rst, checkstack does
not point out problems explicitly, but any one function that uses more
than 512 bytes on the stack is a candidate for change, hence it is better
to omit any stack frame sizes smaller than 512 bytes, just change
min_stack to 512 by default.

Link: https://lkml.kernel.org/r/20231219125008.23007-5-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkstack.pl~scripts-checkstackpl-change-min_stack-to-512-by-default
+++ a/scripts/checkstack.pl
@@ -47,7 +47,7 @@ my (@stack, $re, $dre, $sub, $x, $xs, $f
 
 	$min_stack = shift;
 	if ($min_stack eq "" || $min_stack !~ /^\d+$/) {
-		$min_stack = 100;
+		$min_stack = 512;
 	}
 
 	$x	= "[0-9a-f]";	# hex character
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


