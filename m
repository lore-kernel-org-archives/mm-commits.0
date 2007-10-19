From: akpm@linux-foundation.org
Subject: - pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:15:34 -0700
Message-ID: <200710190415.l9J4FYK5014548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501AbXJSEPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:15:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kernel/pid.c: remove unused exports
has been removed from the -mm tree.  Its filename was
     pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch

This patch was dropped because it was folded into pid-namespaces-define-is_global_init-and-is_container_init.patch

------------------------------------------------------
Subject: kernel/pid.c: remove unused exports
From: Adrian Bunk <bunk@stusta.de>

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +pid-namespaces-define-is_global_init-and-is_container_init.patch
>...
>  pid namespaces
>...

This patch removes two unused exports.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN kernel/pid.c~pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports
+++ a/kernel/pid.c
@@ -69,13 +69,11 @@ struct pid_namespace init_pid_ns = {
 	.last_pid = 0,
 	.child_reaper = &init_task
 };
-EXPORT_SYMBOL(init_pid_ns);
 
 int is_global_init(struct task_struct *tsk)
 {
 	return tsk == init_pid_ns.child_reaper;
 }
-EXPORT_SYMBOL(is_global_init);
 
 /*
  * Note: disable interrupts while the pidmap_lock is held as an
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
