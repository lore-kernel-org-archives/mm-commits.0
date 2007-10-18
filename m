From: akpm@linux-foundation.org
Subject: - serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:28:29 -0700
Message-ID: <200710180828.l9I8STtX002173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57348 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755659AbXJRI3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:29:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, nigel@suspend2.net, pavel@ucw.cz, rjw@sisk.pl, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option update
has been removed from the -mm tree.  Its filename was
     serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch

This patch was dropped because it was folded into serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch

------------------------------------------------------
Subject: serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option update
From: Andres Salomon <dilinger@queued.net>

Russell King <rmk@arm.linux.org.uk> wrote:

> On Tue, Aug 14, 2007 at 12:37:52PM -0700, akpm@linux-foundation.org wrote:
[...]
> > @@ -810,7 +810,15 @@ int update_console_cmdline(char *name, i
> >  	return -1;
> >  }
> >
> > -#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
> > +int console_suspend_enabled = 1;
>
> This needs to be exported.
>

Thanks for pointing that out; I've updated the patch.  Andrew, can you
please swap this one in?

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@suspend2.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN kernel/printk.c~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update kernel/printk.c
--- a/kernel/printk.c~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update
+++ a/kernel/printk.c
@@ -811,6 +811,7 @@ int update_console_cmdline(char *name, i
 }
 
 int console_suspend_enabled = 1;
+EXPORT_SYMBOL(console_suspend_enabled);
 
 static int __init console_suspend_disable(char *str)
 {
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
