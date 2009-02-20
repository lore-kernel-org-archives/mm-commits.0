From: akpm@linux-foundation.org
Subject: + x86-conform-l3-cache-index-disable-to-linux-standards.patch added to -mm tree
Date: Fri, 20 Feb 2009 14:50:16 -0800
Message-ID: <200902202250.n1KMoHmE005473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbZBTWv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Feb 2009 17:51:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.langsdorf@amd.com, eric@lammerts.org, hpa@zytor.com, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     x86: Conform L3 Cache Index Disable to Linux standards
has been added to the -mm tree.  Its filename is
     x86-conform-l3-cache-index-disable-to-linux-standards.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: x86: Conform L3 Cache Index Disable to Linux standards
=46rom: Mark Langsdorf <mark.langsdorf@amd.com>

Add ABI Documentation entry and fix some /sys directory formating
issues with the L3 Cache Index Disable feature for future AMD
processors. =A0Add a check to disable it for family 0x10 models
that do not support it yet.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric Lammerts <eric@lammerts.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-cache_disable |   18 +
 arch/x86/kernel/cpu/intel_cacheinfo.c                 |  178 ++++-----=
-
 2 files changed, 94 insertions(+), 102 deletions(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-devices-cache_disab=
le
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-devices-cache_disable
@@ -0,0 +1,18 @@
+What:	    /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
+Date:	    August 2008
+KernelVersion:  2.6.27
+Contact:	 mark.langsdorf@amd.com
+Description:    These files exist in every cpu's cache index directori=
es.
+		 There are currently 2 cache_disable_# files in each
+		 directory.  Reading from these files on a supported
+		 processor will return that cache disable index value
+		 for that processor and node.  Writing to one of these
+		 files will cause the specificed cache index to be disabled.
+
+		 Currently, only AMD Family 10h Processors support cache index
+		 disable, and only for their L3 caches.  See the BIOS and
+		 Kernel Developer's Guide at
+		http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_d=
ocs/31116-Public-GH-BKDG_3.20_2-4-09.pdf
+		 for formatting information and other details on the
+		 cache index disable.
+Users:	   joachim.deguara@amd.com
diff -puN arch/x86/kernel/cpu/intel_cacheinfo.c~x86-conform-l3-cache-in=
dex-disable-to-linux-standards arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~x86-conform-l3-cache-index-=
disable-to-linux-standards
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -18,6 +18,9 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
=20
+#include <linux/pci.h>
+#include <asm/k8.h>
+
 #define LVL_1_INST	1
 #define LVL_1_DATA	2
 #define LVL_2		3
@@ -159,14 +162,6 @@ struct _cpuid4_info_regs {
 	unsigned long can_disable;
 };
=20
-#ifdef CONFIG_PCI
-static struct pci_device_id k8_nb_id[] =3D {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
-	{}
-};
-#endif
-
 unsigned short			num_cache_leaves;
=20
 /* AMD doesn't have CPUID4. Emulate it here to report the same
@@ -291,6 +286,12 @@ amd_check_l3_disable(int index, struct _
 {
 	if (index < 3)
 		return;
+	if (boot_cpu_data.x86 =3D=3D 0x11)
+		return;
+
+	if ((boot_cpu_data.x86 =3D=3D 0x10) && (boot_cpu_data.x86_model < 0x1=
5))
+		return;
+
 	this_leaf->can_disable =3D 1;
 }
=20
@@ -639,6 +640,66 @@ static ssize_t show_##file_name						\
 	return sprintf (buf, "%lu\n", (unsigned long)this_leaf->object + val)=
; \
 }
=20
+static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char=
 *buf,
+		 unsigned int index)
+{
+	const struct cpumask *mask =3D to_cpumask(this_leaf->shared_cpu_map);
+	int node =3D cpu_to_node(cpumask_first(mask));
+	struct pci_dev *dev =3D k8_northbridges[node];
+	unsigned int reg =3D 0;
+
+	if (!this_leaf->can_disable)
+		return -EINVAL;
+
+	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
+	return sprintf(buf, "%x\n", reg);
+}
+
+#define SHOW_CACHE_DISABLE(index)					\
+static ssize_t								\
+show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf) =
 	\
+{									\
+	return show_cache_disable(this_leaf, buf, index);		\
+}
+
+static ssize_t
+store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
+		 size_t count, unsigned int index)
+{
+	const struct cpumask *mask =3D to_cpumask(this_leaf->shared_cpu_map);
+	int node =3D cpu_to_node(cpumask_first(mask));
+	struct pci_dev *dev =3D k8_northbridges[node];
+	unsigned long val =3D 0;
+
+	if (!this_leaf->can_disable)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	val |=3D 0xc0000000;
+	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
+	wbinvd();
+	pci_write_config_dword(dev, 0x1BC + index * 4, val);
+	return count;
+}
+
+#define STORE_CACHE_DISABLE(index)					\
+static ssize_t								\
+store_cache_disable_##index(struct _cpuid4_info *this_leaf,	     	\
+		 const char *buf, size_t count)			     	\
+{									\
+	return store_cache_disable(this_leaf, buf, count, index);	\
+}
+
+SHOW_CACHE_DISABLE(0)
+STORE_CACHE_DISABLE(0)
+SHOW_CACHE_DISABLE(1)
+STORE_CACHE_DISABLE(1)
+
 show_one_plus(level, eax.split.level, 0);
 show_one_plus(coherency_line_size, ebx.split.coherency_line_size, 1);
 show_one_plus(physical_line_partition, ebx.split.physical_line_partiti=
on, 1);
@@ -696,98 +757,6 @@ static ssize_t show_type(struct _cpuid4_
 #define to_object(k)	container_of(k, struct _index_kobject, kobj)
 #define to_attr(a)	container_of(a, struct _cache_attr, attr)
=20
-#ifdef CONFIG_PCI
-static struct pci_dev *get_k8_northbridge(int node)
-{
-	struct pci_dev *dev =3D NULL;
-	int i;
-
-	for (i =3D 0; i <=3D node; i++) {
-		do {
-			dev =3D pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
-			if (!dev)
-				break;
-		} while (!pci_match_id(&k8_nb_id[0], dev));
-		if (!dev)
-			break;
-	}
-	return dev;
-}
-#else
-static struct pci_dev *get_k8_northbridge(int node)
-{
-	return NULL;
-}
-#endif
-
-static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char=
 *buf)
-{
-	const struct cpumask *mask =3D to_cpumask(this_leaf->shared_cpu_map);
-	int node =3D cpu_to_node(cpumask_first(mask));
-	struct pci_dev *dev =3D NULL;
-	ssize_t ret =3D 0;
-	int i;
-
-	if (!this_leaf->can_disable)
-		return sprintf(buf, "Feature not enabled\n");
-
-	dev =3D get_k8_northbridge(node);
-	if (!dev) {
-		printk(KERN_ERR "Attempting AMD northbridge operation on a system wi=
th no northbridge\n");
-		return -EINVAL;
-	}
-
-	for (i =3D 0; i < 2; i++) {
-		unsigned int reg;
-
-		pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
-
-		ret +=3D sprintf(buf, "%sEntry: %d\n", buf, i);
-		ret +=3D sprintf(buf, "%sReads:  %s\tNew Entries: %s\n", =20
-			buf,
-			reg & 0x80000000 ? "Disabled" : "Allowed",
-			reg & 0x40000000 ? "Disabled" : "Allowed");
-		ret +=3D sprintf(buf, "%sSubCache: %x\tIndex: %x\n",
-			buf, (reg & 0x30000) >> 16, reg & 0xfff);
-	}
-	return ret;
-}
-
-static ssize_t
-store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
-		    size_t count)
-{
-	const struct cpumask *mask =3D to_cpumask(this_leaf->shared_cpu_map);
-	int node =3D cpu_to_node(cpumask_first(mask));
-	struct pci_dev *dev =3D NULL;
-	unsigned int ret, index, val;
-
-	if (!this_leaf->can_disable)
-		return 0;
-
-	if (strlen(buf) > 15)
-		return -EINVAL;
-
-	ret =3D sscanf(buf, "%x %x", &index, &val);
-	if (ret !=3D 2)
-		return -EINVAL;
-	if (index > 1)
-		return -EINVAL;
-
-	val |=3D 0xc0000000;
-	dev =3D get_k8_northbridge(node);
-	if (!dev) {
-		printk(KERN_ERR "Attempting AMD northbridge operation on a system wi=
th no northbridge\n");
-		return -EINVAL;
-	}
-
-	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
-	wbinvd();
-	pci_write_config_dword(dev, 0x1BC + index * 4, val);
-
-	return 1;
-}
-
 struct _cache_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct _cpuid4_info *, char *);
@@ -808,7 +777,11 @@ define_one_ro(size);
 define_one_ro(shared_cpu_map);
 define_one_ro(shared_cpu_list);
=20
-static struct _cache_attr cache_disable =3D __ATTR(cache_disable, 0644=
, show_cache_disable, store_cache_disable);
+static struct _cache_attr cache_disable_0 =3D __ATTR(cache_disable_0, =
0644,
+		 show_cache_disable_0, store_cache_disable_0);
+static struct _cache_attr cache_disable_1 =3D __ATTR(cache_disable_1, =
0644,
+		 show_cache_disable_1, store_cache_disable_1);
+
=20
 static struct attribute * default_attrs[] =3D {
 	&type.attr,
@@ -820,7 +793,8 @@ static struct attribute * default_attrs[
 	&size.attr,
 	&shared_cpu_map.attr,
 	&shared_cpu_list.attr,
-	&cache_disable.attr,
+	&cache_disable_0.attr,
+	&cache_disable_1.attr,
 	NULL
 };
=20
_

Patches currently in -mm which might be from mark.langsdorf@amd.com are

x86-conform-l3-cache-index-disable-to-linux-standards.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
