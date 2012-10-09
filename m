From: akpm@linux-foundation.org
Subject: [merged] mm-use-%pk-for-proc-vmallocinfo.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:15:07 -0700
Message-ID: <20121009181508.24AF95C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:36134 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2JISPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:15:10 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so363236lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:15:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, spender@grsecurity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use %pK for /proc/vmallocinfo
has been removed from the -mm tree.  Its filename was
     mm-use-%pk-for-proc-vmallocinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm: use %pK for /proc/vmallocinfo

In the paranoid case of sysctl kernel.kptr_restrict=2, mask the kernel
virtual addresses in /proc/vmallocinfo too.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Brad Spengler <spender@grsecurity.net>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-use-%pk-for-proc-vmallocinfo mm/vmalloc.c
--- a/mm/vmalloc.c~mm-use-%pk-for-proc-vmallocinfo
+++ a/mm/vmalloc.c
@@ -2571,7 +2571,7 @@ static int s_show(struct seq_file *m, vo
 {
 	struct vm_struct *v = p;
 
-	seq_printf(m, "0x%p-0x%p %7ld",
+	seq_printf(m, "0x%pK-0x%pK %7ld",
 		v->addr, v->addr + v->size, v->size);
 
 	if (v->caller)
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch

