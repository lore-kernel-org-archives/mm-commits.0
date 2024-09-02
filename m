Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C723A32
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248790; cv=none; b=Bn8zalhCXat1bRYLW+SGrgrhTF6+d4P4zEvIubIv8VXcmU2zJjTjPdipJ2fOIvmauChcz8xIx6uR1Y/9CyVL3De7dQFV0bYnaT1BuW17xYBKEm1Me7zD5Tpd4X30pgV8yIr779LQ/tGcynu8fA/uCtsDZA+0neIxA+tGrWrhad0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248790; c=relaxed/simple;
	bh=gJDTd2RC8zBPZFnzrwn74r+XkRMVpCWGZ4DLocTmdBQ=;
	h=Date:To:From:Subject:Message-Id; b=Ukd1dPeQQOuNksLvVZ4Q6V2reybqryOywQeDvuycwbm5YiEXyF6uWvI49PYzdLLA0TL36G/1p0OxiBx7x+nzdvLSyMleZ8mBpEldH1/vguBzHbIMwmxWVFuMXNfDQrnK/2v0f47aL1AEf4L6P6UEAnUPyntXqPQMi7aIf5aRKmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=toFQE7uH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="toFQE7uH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E0CC4CEC2;
	Mon,  2 Sep 2024 03:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248789;
	bh=gJDTd2RC8zBPZFnzrwn74r+XkRMVpCWGZ4DLocTmdBQ=;
	h=Date:To:From:Subject:From;
	b=toFQE7uHaygw/k39aIdv1pgoMIn1WR+SfUD/L5CMVql7LKewv9fdiYsD79gw0kKn9
	 qceQJpcCCZF20LW/Qd6wgomerPA6FzU6GPDlCBLqfqysoDRh/VSBUD0DgjWVXwOd71
	 yRu/4FChBpc+1Dm0MG6qQLdPiR+FbdrlxP8x9ENY=
Date: Sun, 01 Sep 2024 20:46:29 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,elfring@users.sourceforge.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] closures-use-seq_putc-in-debug_show.patch removed from -mm tree
Message-Id: <20240902034629.D6E0CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: closures: use seq_putc() in debug_show()
has been removed from the -mm tree.  Its filename was
     closures-use-seq_putc-in-debug_show.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: closures: use seq_putc() in debug_show()
Date: Sun, 14 Jul 2024 19:15:09 +0200

A single line break should be put into a sequence.  Thus use the
corresponding function "seq_putc".

This issue was transformed by using the Coccinelle software.

Link: https://lkml.kernel.org/r/e7faa2c4-9590-44b4-8669-69ef810277b1@web.de
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/closure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/closure.c~closures-use-seq_putc-in-debug_show
+++ a/lib/closure.c
@@ -278,7 +278,7 @@ static int debug_show(struct seq_file *f
 			seq_printf(f, " W %pS\n",
 				   (void *) cl->waiting_on);
 
-		seq_puts(f, "\n");
+		seq_putc(f, '\n');
 	}
 
 	spin_unlock_irq(&closure_list_lock);
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are


