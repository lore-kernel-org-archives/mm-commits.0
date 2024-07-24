Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1AC15F318
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 17:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721843105; cv=none; b=YBcvtscYYDScLi4nol7WfE47Gh9EE26k8VNgHVP3d/GRqUUqzD8JC/Q23MFTrDIyOZ8DLaMNCv5RogfOfeFysmskpVQnblTE8CU/8vDHywDHhbUrp85VXYaq4ESRLjEpDNoqcWv8sviQDtDYbRYaCtS4As0hZB979SVs/miYAns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721843105; c=relaxed/simple;
	bh=FmeVrrKtUhUBnXkVZkpc897r+JEaWFZizXNQJxw+1Bw=;
	h=Date:To:From:Subject:Message-Id; b=ckmPmpHffFK3SHjbtGHsaXOMy2vRU8ZRv3cHx0bGhbCaUbD9qs3oFObIlLKy+RM+jy9wg3zopVp8BwPyNJsNrx+z9fTUPIsgWU4XH7+4E/qWlXaOqwr8EtUmppdLrB7VMJyGDyTbW2xA2fDMMLD/oRnbHRST/xFH0IFDl7nH+xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdftmvnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdftmvnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82385C32781;
	Wed, 24 Jul 2024 17:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721843104;
	bh=FmeVrrKtUhUBnXkVZkpc897r+JEaWFZizXNQJxw+1Bw=;
	h=Date:To:From:Subject:From;
	b=gdftmvnIQFDteefnjgvaMnxzXX7PiVlBsuG0xpO8G/jKoL9/e8ydsu6GAI50iuiBz
	 xk6jCjHasi73vQogkSctdtT4OHHFN0KPa4YGQY3AuV2JuoRvyAU3AGs1ptfToI7Gm9
	 EJ6vVKOZqqLVOfIsnVL5Oj7KqRchXEw1cDjnY4Ro=
Date: Wed, 24 Jul 2024 10:45:04 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,elfring@users.sourceforge.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + closures-use-seq_putc-in-debug_show.patch added to mm-nonmm-unstable branch
Message-Id: <20240724174504.82385C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: closures: use seq_putc() in debug_show()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     closures-use-seq_putc-in-debug_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/closures-use-seq_putc-in-debug_show.patch

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

dyndbg-use-seq_putc-in-ddebug_proc_show.patch
closures-use-seq_putc-in-debug_show.patch

