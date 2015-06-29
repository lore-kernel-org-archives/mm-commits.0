From: akpm@linux-foundation.org
Subject: [merged] lib-sort-add-64-bit-swap-function.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:47:57 -0700
Message-ID: <5591aefd.FgR0QCckBa+teY3v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbbF2Ur6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.wagner@bmw-carit.de, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/sort: Add 64 bit swap function
has been removed from the -mm tree.  Its filename was
     lib-sort-add-64-bit-swap-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: lib/sort: Add 64 bit swap function

In case the call side is not providing a swap function, we either use a 32
bit or a generic swap function.  When swapping around pointers on 64 bit
architectures falling back to use the generic swap function seems like an
unnecessary waste.

There at least 9 users ('sort' is of difficult to grep for) of sort() and
all of them use the sort function without a customized swap function. 
Furthermore, they are all using pointers to swap around:

arch/x86/kernel/e820.c:sanitize_e820_map()
arch/x86/mm/extable.c:sort_extable()
drivers/acpi/fan.c:acpi_fan_get_fps()
fs/btrfs/super.c:btrfs_descending_sort_devices()
fs/xfs/libxfs/xfs_dir2_block.c:xfs_dir2_sf_to_block()
kernel/range.c:clean_sort_range()
mm/memcontrol.c:__mem_cgroup_usage_register_event()
sound/pci/hda/hda_auto_parser.c:snd_hda_parse_pin_defcfg()
sound/pci/hda/hda_auto_parser.c:sort_pins_by_sequence()

Obviously, we could improve the swap for other sizes as well
but this is overkill at this point.

A simple test shows sorting a 400 element array (try to stay in one
page) with either with u32_swap() or u64_swap() show that the theory
actually works. This test was done on a x86_64 (Intel Xeon E5-4610)
machine.

- swap_32:

NumSamples = 100; Min = 48.00; Max = 49.00
Mean = 48.320000; Variance = 0.217600; SD = 0.466476; Median 48.000000
each * represents a count of 1
   48.0000 -    48.1000 [    68]: ********************************************************************
   48.1000 -    48.2000 [     0]:
   48.2000 -    48.3000 [     0]:
   48.3000 -    48.4000 [     0]:
   48.4000 -    48.5000 [     0]:
   48.5000 -    48.6000 [     0]:
   48.6000 -    48.7000 [     0]:
   48.7000 -    48.8000 [     0]:
   48.8000 -    48.9000 [     0]:
   48.9000 -    49.0000 [    32]: ********************************

- swap_64:

NumSamples = 100; Min = 44.00; Max = 63.00
Mean = 48.250000; Variance = 18.687500; SD = 4.322904; Median 47.000000
each * represents a count of 1
   44.0000 -    45.9000 [    15]: ***************
   45.9000 -    47.8000 [    37]: *************************************
   47.8000 -    49.7000 [    39]: ***************************************
   49.7000 -    51.6000 [     0]:
   51.6000 -    53.5000 [     0]:
   53.5000 -    55.4000 [     0]:
   55.4000 -    57.3000 [     0]:
   57.3000 -    59.2000 [     1]: *
   59.2000 -    61.1000 [     3]: ***
   61.1000 -    63.0000 [     5]: *****

- swap_72:

NumSamples = 100; Min = 53.00; Max = 71.00
Mean = 55.070000; Variance = 21.565100; SD = 4.643824; Median 53.000000
each * represents a count of 1
   53.0000 -    54.8000 [    73]: *************************************************************************
   54.8000 -    56.6000 [     9]: *********
   56.6000 -    58.4000 [     9]: *********
   58.4000 -    60.2000 [     0]:
   60.2000 -    62.0000 [     0]:
   62.0000 -    63.8000 [     0]:
   63.8000 -    65.6000 [     0]:
   65.6000 -    67.4000 [     1]: *
   67.4000 -    69.2000 [     4]: ****
   69.2000 -    71.0000 [     4]: ****

- test program:

static int cmp_32(const void *a, const void *b)
{
	u32 l = *(u32 *)a;
	u32 r = *(u32 *)b;

	if (l < r)
		return -1;
	if (l > r)
		return 1;
	return 0;
}

static int cmp_64(const void *a, const void *b)
{
	u64 l = *(u64 *)a;
	u64 r = *(u64 *)b;

	if (l < r)
		return -1;
	if (l > r)
		return 1;
	return 0;
}

static int cmp_72(const void *a, const void *b)
{
	u32 l = get_unaligned((u32 *) a);
	u32 r = get_unaligned((u32 *) b);

	if (l < r)
		return -1;
	if (l > r)
		return 1;
	return 0;
}

static void init_array32(void *array)
{
	u32 *a = array;
	int i;

	a[0] = 3821;
	for (i = 1; i < ARRAY_ELEMENTS; i++)
		a[i] = next_pseudo_random32(a[i-1]);
}

static void init_array64(void *array)
{
	u64 *a = array;
	int i;

	a[0] = 3821;
	for (i = 1; i < ARRAY_ELEMENTS; i++)
		a[i] = next_pseudo_random32(a[i-1]);
}

static void init_array72(void *array)
{
	char *p;
	u32 v;
	int i;

	v = 3821;
	for (i = 0; i < ARRAY_ELEMENTS; i++) {
		p = (char *)array + (i * 9);
		put_unaligned(v, (u32*) p);
		v = next_pseudo_random32(v);
	}
}

static void sort_test(void (*init)(void *array),
		      int (*cmp) (const void *, const void *),
		      void *array, size_t size)
{
	ktime_t start, stop;
	int i;

	for (i = 0; i < 10000; i++) {
		init(array);

		local_irq_disable();
		start = ktime_get();

		sort(array, ARRAY_ELEMENTS, size, cmp, NULL);

		stop = ktime_get();
		local_irq_enable();

		if (i > 10000 - 101)
		  pr_info("%lld\n",  ktime_to_us(ktime_sub(stop, start)));
	}
}

static void *create_array(size_t size)
{
	void *array;

	array = kmalloc(ARRAY_ELEMENTS * size, GFP_KERNEL);
	if (!array)
		return NULL;

	return array;
}

static int perform_test(size_t size)
{
	void *array;

	array = create_array(size);
	if (!array)
		return -ENOMEM;

	pr_info("test element size %d bytes\n", (int)size);
	switch (size) {
	case 4:
		sort_test(init_array32, cmp_32, array, size);
		break;
	case 8:
		sort_test(init_array64, cmp_64, array, size);
		break;
	case 9:
		sort_test(init_array72, cmp_72, array, size);
		break;
	}
	kfree(array);

	return 0;
}

static int __init sort_tests_init(void)
{
	int err;

	err = perform_test(sizeof(u32));
	if (err)
		return err;

	err = perform_test(sizeof(u64));
	if (err)
		return err;

	err = perform_test(sizeof(u64)+1);
	if (err)
		return err;

	return 0;
}

static void __exit sort_tests_exit(void)
{
}

module_init(sort_tests_init);
module_exit(sort_tests_exit);

MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("Daniel Wagner");
MODULE_DESCRIPTION("sort perfomance tests");


Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN lib/sort.c~lib-sort-add-64-bit-swap-function lib/sort.c
--- a/lib/sort.c~lib-sort-add-64-bit-swap-function
+++ a/lib/sort.c
@@ -8,6 +8,12 @@
 #include <linux/export.h>
 #include <linux/sort.h>
 
+static int alignment_ok(const void *base, int align)
+{
+	return IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+		((unsigned long)base & (align - 1)) == 0;
+}
+
 static void u32_swap(void *a, void *b, int size)
 {
 	u32 t = *(u32 *)a;
@@ -15,6 +21,13 @@ static void u32_swap(void *a, void *b, i
 	*(u32 *)b = t;
 }
 
+static void u64_swap(void *a, void *b, int size)
+{
+	u64 t = *(u64 *)a;
+	*(u64 *)a = *(u64 *)b;
+	*(u64 *)b = t;
+}
+
 static void generic_swap(void *a, void *b, int size)
 {
 	char t;
@@ -50,8 +63,14 @@ void sort(void *base, size_t num, size_t
 	/* pre-scale counters for performance */
 	int i = (num/2 - 1) * size, n = num * size, c, r;
 
-	if (!swap_func)
-		swap_func = (size == 4 ? u32_swap : generic_swap);
+	if (!swap_func) {
+		if (size == 4 && alignment_ok(base, 4))
+			swap_func = u32_swap;
+		else if (size == 8 && alignment_ok(base, 8))
+			swap_func = u64_swap;
+		else
+			swap_func = generic_swap;
+	}
 
 	/* heapify */
 	for ( ; i >= 0; i -= size) {
_

Patches currently in -mm which might be from daniel.wagner@bmw-carit.de are

origin.patch

