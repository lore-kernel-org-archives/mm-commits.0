Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1B4149E06
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248789; cv=none; b=bblK9FT13iRgy+7KsaoWW0CDfHaSvu1AvlT6MQwk7uWkIViE5OAeVtpRPYVCGiaw0o4Rrq4vEaUoObmEUpwzO751uLhnMAVvUe/vnZVjTF0sQHsq9VO4hqdjMvC3J7r2itJwL4LpFY9ZB9HaIgh/8lwmQDKlEJzomXWVkCDFeJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248789; c=relaxed/simple;
	bh=lhoOQtVdfwsb9Yy7jik+jORIuvFudpj6byTHHPz6OiI=;
	h=Date:To:From:Subject:Message-Id; b=Ljk5HwuEXlDNBTrPnUpJlZyPYzZVMc9oaAufW7qrLGboKhow2e4HIFq5byiw3PwVZQNrapeOw/A799owNwKPqqktUBnhKQEi0ITlcfoFXcTNMNnaESaA1kmZtGVJQshjjcW8rmoC+2o1FvzPhhDDFCf9fa3SqPziA0TZEVgsBAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FHpIUqGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FHpIUqGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6384C4CEC2;
	Mon,  2 Sep 2024 03:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248788;
	bh=lhoOQtVdfwsb9Yy7jik+jORIuvFudpj6byTHHPz6OiI=;
	h=Date:To:From:Subject:From;
	b=FHpIUqGAaLxj+SJNKT3mYpBP/JUfRSRgmPlwfO+ZWBSNI/qediXUnTwG0Cxab6fru
	 crUXUrp7TuB9ofmtL+BJSpB4pUkx99ESR9EfYMD7K7US9PmiaNdtG2zb70gmiXfXA1
	 msuc/33MeQp/LjGgUEfgriJJyEkXkj/t2mpPDLTQ=
Date: Sun, 01 Sep 2024 20:46:28 -0700
To: mm-commits@vger.kernel.org,jim.cromie@gmail.com,jbaron@akamai.com,elfring@users.sourceforge.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] dyndbg-use-seq_putc-in-ddebug_proc_show.patch removed from -mm tree
Message-Id: <20240902034628.C6384C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dyndbg: use seq_putc() in ddebug_proc_show()
has been removed from the -mm tree.  Its filename was
     dyndbg-use-seq_putc-in-ddebug_proc_show.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


