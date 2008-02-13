From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-support-multiple-probes-spufs-fix.patch added to -mm tree
Date: Tue, 12 Feb 2008 16:11:31 -0800
Message-ID: <200802130011.m1D0BVhL030318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343AbYBMANR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 19:13:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: compudj@krystal.dyndns.org, fche@redhat.com, hch@infradead.org, mathieu.desnoyers@polymtl.ca, rostedt@goodmis.org


The patch titled
     spufs support multiple probes markers
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-support-multiple-probes-spufs-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spufs support multiple probes markers
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>

Update spufs to the new linux kernel markers API, which supports connecting
more than one probe to a single marker.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/sputrace.c |   31 ++++++-----------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/sputrace.c~linux-kernel-markers-support-multiple-probes-spufs-fix arch/powerpc/platforms/cell/spufs/sputrace.c
--- a/arch/powerpc/platforms/cell/spufs/sputrace.c~linux-kernel-markers-support-multiple-probes-spufs-fix
+++ a/arch/powerpc/platforms/cell/spufs/sputrace.c
@@ -146,34 +146,28 @@ static void sputrace_log_item(const char
 	wake_up(&sputrace_wait);
 }
 
-static void spu_context_event(const struct marker *mdata,
-		void *private, const char *format, ...)
+static void spu_context_event(void *probe_private, void *call_data,
+		const char *format, va_list *args)
 {
-	struct spu_probe *p = mdata->private;
-	va_list ap;
+	struct spu_probe *p = probe_private;
 	struct spu_context *ctx;
 	struct spu *spu;
 
-	va_start(ap, format);
-	ctx = va_arg(ap, struct spu_context *);
-	spu = va_arg(ap, struct spu *);
+	ctx = va_arg(*args, struct spu_context *);
+	spu = va_arg(*args, struct spu *);
 
 	sputrace_log_item(p->name, ctx, spu);
-	va_end(ap);
 }
 
-static void spu_context_nospu_event(const struct marker *mdata,
-		void *private, const char *format, ...)
+static void spu_context_nospu_event(void *probe_private, void *call_data,
+		const char *format, va_list *args)
 {
-	struct spu_probe *p = mdata->private;
-	va_list ap;
+	struct spu_probe *p = probe_private;
 	struct spu_context *ctx;
 
-	va_start(ap, format);
-	ctx = va_arg(ap, struct spu_context *);
+	ctx = va_arg(*args, struct spu_context *);
 
 	sputrace_log_item(p->name, ctx, NULL);
-	va_end(ap);
 }
 
 struct spu_probe spu_probes[] = {
@@ -219,10 +213,6 @@ static int __init sputrace_init(void)
 		if (error)
 			printk(KERN_INFO "Unable to register probe %s\n",
 					p->name);
-
-		error = marker_arm(p->name);
-		if (error)
-			printk(KERN_INFO "Unable to arm probe %s\n", p->name);
 	}
 
 	return 0;
@@ -238,7 +228,8 @@ static void __exit sputrace_exit(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(spu_probes); i++)
-		marker_probe_unregister(spu_probes[i].name);
+		marker_probe_unregister(spu_probes[i].name,
+			spu_probes[i].probe_func, &spu_probes[i]);
 
 	remove_proc_entry("sputrace", NULL);
 	kfree(sputrace_log);
_

Patches currently in -mm which might be from compudj@krystal.dyndns.org are

origin.patch
fix-frv-cmpxchg_local.patch
linux-kernel-markers-support-multiple-probes-spufs-fix.patch
