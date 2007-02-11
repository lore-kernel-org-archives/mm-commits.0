From: akpm@linux-foundation.org
Subject: - uml-use-list_head-where-possible.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:45 -0800
Message-ID: <200702112248.l1BMmjo9015660@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59767 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678AbXBKWsr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: use LIST_HEAD where possible
has been removed from the -mm tree.  Its filename was
     uml-use-list_head-where-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: use LIST_HEAD where possible
From: Jeff Dike <jdike@addtoit.com>

A couple of list_head declarations can be improved through the use of
LIST_HEAD().

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |    2 +-
 arch/um/drivers/port_kern.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-use-list_head-where-possible arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-use-list_head-where-possible
+++ a/arch/um/drivers/mconsole_kern.c
@@ -371,7 +371,7 @@ struct unplugged_pages {
 
 static DECLARE_MUTEX(plug_mem_mutex);
 static unsigned long long unplugged_pages_count = 0;
-static struct list_head unplugged_pages = LIST_HEAD_INIT(unplugged_pages);
+static LIST_HEAD(unplugged_pages);
 static int unplug_index = UNPLUGGED_PER_PAGE;
 
 static int mem_config(char *str, char **error_out)
diff -puN arch/um/drivers/port_kern.c~uml-use-list_head-where-possible arch/um/drivers/port_kern.c
--- a/arch/um/drivers/port_kern.c~uml-use-list_head-where-possible
+++ a/arch/um/drivers/port_kern.c
@@ -130,7 +130,7 @@ static int port_accept(struct port_list 
 }
 
 static DECLARE_MUTEX(ports_sem);
-static struct list_head ports = LIST_HEAD_INIT(ports);
+static LIST_HEAD(ports);
 
 void port_work_proc(struct work_struct *unused)
 {
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
