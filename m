From: akpm@linux-foundation.org
Subject: + memrlimit-setup-the-memrlimit-controller.patch added to -mm tree
Date: Wed, 21 May 2008 21:29:19 -0700
Message-ID: <200805220429.m4M4TJVX017022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbYEVEaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 00:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memrlimit: setup the memrlimit controller
has been added to the -mm tree.  Its filename is
     memrlimit-setup-the-memrlimit-controller.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: memrlimit: setup the memrlimit controller
=46rom: Balbir Singh <balbir@linux.vnet.ibm.com>

This patch sets up the rlimit cgroup controller. It adds the basic crea=
te,
destroy and populate functionality. The user interface provided is very
similar to the memory resource controller. The rlimit controller can be
enhanced easily in the future to control mlocked pages.

Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup_subsys.h   |    4=20
 include/linux/memrlimitcgroup.h |   19 +++
 init/Kconfig                    |   10 ++
 mm/Makefile                     |    1=20
 mm/memrlimitcgroup.c            |  144 ++++++++++++++++++++++++++++++
 5 files changed, 178 insertions(+)

diff -puN include/linux/cgroup_subsys.h~memrlimit-setup-the-memrlimit-c=
ontroller include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~memrlimit-setup-the-memrlimit-contr=
oller
+++ a/include/linux/cgroup_subsys.h
@@ -47,4 +47,8 @@ SUBSYS(mem_cgroup)
 SUBSYS(devices)
 #endif
=20
+#ifdef CONFIG_CGROUP_MEMRLIMIT_CTLR
+SUBSYS(memrlimit_cgroup)
+#endif
+
 /* */
diff -puN /dev/null include/linux/memrlimitcgroup.h
--- /dev/null
+++ a/include/linux/memrlimitcgroup.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright =C2=A9 International Business Machines  Corp., 2008
+ *
+ * Author: Balbir Singh <balbir@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef LINUX_MEMRLIMITCGROUP_H
+#define LINUX_MEMRLIMITCGROUP_H
+
+#endif /* LINUX_MEMRLIMITCGROUP_H */
diff -puN init/Kconfig~memrlimit-setup-the-memrlimit-controller init/Kc=
onfig
--- a/init/Kconfig~memrlimit-setup-the-memrlimit-controller
+++ a/init/Kconfig
@@ -407,6 +407,16 @@ config CGROUP_MEM_RES_CTLR
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.
=20
+config CGROUP_MEMRLIMIT_CTLR
+	bool "Memory resource limit controls for cgroups"
+	depends on CGROUPS && RESOURCE_COUNTERS && MMU
+	select MM_OWNER
+	help
+	  Provides resource limits for all the tasks belonging to a
+	  control group. CGROUP_MEM_RES_CTLR provides support for physical
+	  memory RSS and Page Cache control. Virtual address space control
+	  is provided by this controller.
+
 config SYSFS_DEPRECATED
 	bool
=20
diff -puN mm/Makefile~memrlimit-setup-the-memrlimit-controller mm/Makef=
ile
--- a/mm/Makefile~memrlimit-setup-the-memrlimit-controller
+++ a/mm/Makefile
@@ -34,4 +34,5 @@ obj-$(CONFIG_MIGRATION) +=3D migrate.o
 obj-$(CONFIG_SMP) +=3D allocpercpu.o
 obj-$(CONFIG_QUICKLIST) +=3D quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) +=3D memcontrol.o
+obj-$(CONFIG_CGROUP_MEMRLIMIT_CTLR) +=3D memrlimitcgroup.o
=20
diff -puN /dev/null mm/memrlimitcgroup.c
--- /dev/null
+++ a/mm/memrlimitcgroup.c
@@ -0,0 +1,144 @@
+/*
+ * Copyright =C2=A9 International Business Machines  Corp., 2008
+ *
+ * Author: Balbir Singh <balbir@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Provide memory resource limits for tasks in a control group. A lot =
of code is
+ * duplicated from the memory controller (this code is common to almos=
t
+ * all controllers). TODO: Consider writing a tool that can generate t=
his
+ * code.
+ */
+#include <linux/cgroup.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
+#include <linux/swap.h>
+#include <linux/spinlock.h>
+#include <linux/fs.h>
+#include <linux/res_counter.h>
+#include <linux/memrlimitcgroup.h>
+
+struct cgroup_subsys memrlimit_cgroup_subsys;
+
+struct memrlimit_cgroup {
+	struct cgroup_subsys_state css;
+	struct res_counter as_res;	/* address space counter */
+};
+
+static struct memrlimit_cgroup init_memrlimit_cgroup;
+
+static struct memrlimit_cgroup *memrlimit_cgroup_from_cgrp(struct cgro=
up *cgrp)
+{
+	return container_of(cgroup_subsys_state(cgrp,
+				memrlimit_cgroup_subsys_id),
+				struct memrlimit_cgroup, css);
+}
+
+static struct cgroup_subsys_state *
+memrlimit_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct memrlimit_cgroup *memrcg;
+
+	if (unlikely(cgrp->parent =3D=3D NULL))
+		memrcg =3D &init_memrlimit_cgroup;
+	else {
+		memrcg =3D kzalloc(sizeof(*memrcg), GFP_KERNEL);
+		if (!memrcg)
+			return ERR_PTR(-ENOMEM);
+	}
+	res_counter_init(&memrcg->as_res);
+	return &memrcg->css;
+}
+
+static void memrlimit_cgroup_destroy(struct cgroup_subsys *ss,
+					struct cgroup *cgrp)
+{
+	kfree(memrlimit_cgroup_from_cgrp(cgrp));
+}
+
+static int memrlimit_cgroup_reset(struct cgroup *cgrp, unsigned int ev=
ent)
+{
+	struct memrlimit_cgroup *memrcg;
+
+	memrcg =3D memrlimit_cgroup_from_cgrp(cgrp);
+	switch (event) {
+	case RES_FAILCNT:
+		res_counter_reset_failcnt(&memrcg->as_res);
+		break;
+	}
+	return 0;
+}
+
+static u64 memrlimit_cgroup_read(struct cgroup *cgrp, struct cftype *c=
ft)
+{
+	return res_counter_read_u64(&memrlimit_cgroup_from_cgrp(cgrp)->as_res=
,
+					cft->private);
+}
+
+static int memrlimit_cgroup_write_strategy(char *buf, unsigned long lo=
ng *tmp)
+{
+	*tmp =3D memparse(buf, &buf);
+	if (*buf !=3D '\0')
+		return -EINVAL;
+
+	*tmp =3D PAGE_ALIGN(*tmp);
+	return 0;
+}
+
+static ssize_t memrlimit_cgroup_write(struct cgroup *cgrp, struct cfty=
pe *cft,
+					struct file *file,
+					const char __user *userbuf,
+					size_t nbytes,
+					loff_t *ppos)
+{
+	return res_counter_write(&memrlimit_cgroup_from_cgrp(cgrp)->as_res,
+					cft->private, userbuf, nbytes, ppos,
+					memrlimit_cgroup_write_strategy);
+}
+
+static struct cftype memrlimit_cgroup_files[] =3D {
+	{
+		.name =3D "usage_in_bytes",
+		.private =3D RES_USAGE,
+		.read_u64 =3D memrlimit_cgroup_read,
+	},
+	{
+		.name =3D "limit_in_bytes",
+		.private =3D RES_LIMIT,
+		.write =3D memrlimit_cgroup_write,
+		.read_u64 =3D memrlimit_cgroup_read,
+	},
+	{
+		.name =3D "failcnt",
+		.private =3D RES_FAILCNT,
+		.trigger =3D memrlimit_cgroup_reset,
+		.read_u64 =3D memrlimit_cgroup_read,
+	},
+};
+
+static int memrlimit_cgroup_populate(struct cgroup_subsys *ss,
+					struct cgroup *cgrp)
+{
+	return cgroup_add_files(cgrp, ss, memrlimit_cgroup_files,
+				ARRAY_SIZE(memrlimit_cgroup_files));
+}
+
+struct cgroup_subsys memrlimit_cgroup_subsys =3D {
+	.name =3D "memrlimit",
+	.subsys_id =3D memrlimit_cgroup_subsys_id,
+	.create =3D memrlimit_cgroup_create,
+	.destroy =3D memrlimit_cgroup_destroy,
+	.populate =3D memrlimit_cgroup_populate,
+	.early_init =3D 0,
+};
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com =
are

linux-next.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
