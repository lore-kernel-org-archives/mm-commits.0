Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C1C16A95C
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 17:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721843103; cv=none; b=gPm8Pjb4ZzmIld4InscLe3sZcFuY4BWP3zihRP8YbRAPQJ8SknHQ1heXtcoWpZyHI1umBJHbXwqjgLi9N16nBSX+UIlHVPsgwtdbwIV8066XKmTrgKjl5XAywRvCuGmXTkpgpsN4/m6XxpqCAU1BlQVmGCQC3hEv3S4GOHlL1Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721843103; c=relaxed/simple;
	bh=tZaysXnLp0uAEwfUhJciKvmIUMM2xexweCDZ58S2Kfc=;
	h=Date:To:From:Subject:Message-Id; b=t2M1+o/EoaBKpCAKYHD4Fux1hSlVS8enwssnO7hysc3aSnozAkKJj0QquMTC/70Jn8UoUylmkNKAn9NJROluG5VOiBiY58+0ZJ0xnhrVAY8AiwZvEUPktATSTKMfx1gqhVA3FElRH4K0KS3MeNC7AXknP4rBrnDC3N5H34env10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U5HsTp0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U5HsTp0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BEEC32781;
	Wed, 24 Jul 2024 17:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721843102;
	bh=tZaysXnLp0uAEwfUhJciKvmIUMM2xexweCDZ58S2Kfc=;
	h=Date:To:From:Subject:From;
	b=U5HsTp0lw9iQyjF3sFV7IKibrjiXjRdktcDn8nEMvKjDik9G030bj75byyTe63x5G
	 azYw1r30YUXAV/cx4ZMRzuSY4sgy5bqA6Civ6LgwF4dzgKt1zpUaNGrzkxYlXsRfXu
	 5gV/nDolSn6mZAAvxEEMaEUOjMNSpB4k07JZZwaw=
Date: Wed, 24 Jul 2024 10:45:02 -0700
To: mm-commits@vger.kernel.org,jim.cromie@gmail.com,jbaron@akamai.com,elfring@users.sourceforge.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dyndbg-use-seq_putc-in-ddebug_proc_show.patch added to mm-nonmm-unstable branch
Message-Id: <20240724174502.B6BEEC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dyndbg: use seq_putc() in ddebug_proc_show()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dyndbg-use-seq_putc-in-ddebug_proc_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dyndbg-use-seq_putc-in-ddebug_proc_show.patch

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
Subject: dyndbg: use seq_putc() in ddebug_proc_show()
Date: Sun, 14 Jul 2024 19:33:07 +0200

Single characters should be put into a sequence.  Thus use the
corresponding function "seq_putc".

This issue was transformed by using the Coccinelle software.

Link: https://lkml.kernel.org/r/375b5b4b-6295-419e-bae9-da724a7a682d@web.de
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/dynamic_debug.c~dyndbg-use-seq_putc-in-ddebug_proc_show
+++ a/lib/dynamic_debug.c
@@ -1147,7 +1147,7 @@ static int ddebug_proc_show(struct seq_f
 		   iter->table->mod_name, dp->function,
 		   ddebug_describe_flags(dp->flags, &flags));
 	seq_escape_str(m, dp->format, ESCAPE_SPACE, "\t\r\n\"");
-	seq_puts(m, "\"");
+	seq_putc(m, '"');
 
 	if (dp->class_id != _DPRINTK_CLASS_DFLT) {
 		class = ddebug_class_name(iter, dp);
@@ -1156,7 +1156,7 @@ static int ddebug_proc_show(struct seq_f
 		else
 			seq_printf(m, " class unknown, _id:%d", dp->class_id);
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	return 0;
 }
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

dyndbg-use-seq_putc-in-ddebug_proc_show.patch
closures-use-seq_putc-in-debug_show.patch

