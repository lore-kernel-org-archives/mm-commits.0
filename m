From: akpm@linux-foundation.org
Subject: + lib-sort-add-64-bit-swap-function.patch added to -mm tree
Date: Tue, 28 Apr 2015 14:53:19 -0700
Message-ID: <5540014f.YcyMhgw5bKMWpr55%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030711AbbD1VxU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 17:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.wagner@bmw-carit.de, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/sort: Add 64 bit swap function
has been added to the -mm tree.  Its filename is
     lib-sort-add-64-bit-swap-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-sort-add-64-bit-swap-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-sort-add-64-bit-swap-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Obviously, we could improve the swap for other sizes as well but this is
overkill at this point.

A simple test shows sorting a 400 element array (try to stay in one page)
with either with u32_swap() or u64_swap() show that the theory actually
works.  This test was done on a x86_64 (Intel Xeon E5-4610) machine.

$ cat u32_swap.old | histogram.py
 NumSamples = 99; Min = 26.00; Max = 37.00
 Mean = 28.494949; Variance = 1.542904; SD = 1.242137; Median 28.000000
 each * represents a count of 1
   26.0000 -    27.1000 [    13]: *************
   27.1000 -    28.2000 [    44]: ********************************************
   28.2000 -    29.3000 [    28]: ****************************
   29.3000 -    30.4000 [    13]: *************
   30.4000 -    31.5000 [     0]:
   31.5000 -    32.6000 [     0]:
   32.6000 -    33.7000 [     0]:
   33.7000 -    34.8000 [     0]:
   34.8000 -    35.9000 [     0]:
   35.9000 -    37.0000 [     1]: *

$ cat u32_swap.new | histogram.py
 NumSamples = 99; Min = 26.00; Max = 28.00
 Mean = 27.030303; Variance = 0.191001; SD = 0.437037; Median 27.000000
 each * represents a count of 1
   26.0000 -    26.2000 [     8]: ********
   26.2000 -    26.4000 [     0]:
   26.4000 -    26.6000 [     0]:
   26.6000 -    26.8000 [     0]:
   26.8000 -    27.0000 [    80]: ********************************************************************************
   27.0000 -    27.2000 [     0]:
   27.2000 -    27.4000 [     0]:
   27.4000 -    27.6000 [     0]:
   27.6000 -    27.8000 [     0]:
   27.8000 -    28.0000 [    11]: ***********

$ cat u64_swap.old | histogram.py
 NumSamples = 99; Min = 43.00; Max = 45.00
 Mean = 44.060606; Variance = 0.137741; SD = 0.371135; Median 44.000000
 each * represents a count of 1
   43.0000 -    43.2000 [     4]: ****
   43.2000 -    43.4000 [     0]:
   43.4000 -    43.6000 [     0]:
   43.6000 -    43.8000 [     0]:
   43.8000 -    44.0000 [    85]: *************************************************************************************
   44.0000 -    44.2000 [     0]:
   44.2000 -    44.4000 [     0]:
   44.4000 -    44.6000 [     0]:
   44.6000 -    44.8000 [     0]:
   44.8000 -    45.0000 [    10]: **********

$ cat u64_swap.new | histogram.py
 NumSamples = 99; Min = 26.00; Max = 32.00
 Mean = 26.939394; Variance = 0.400367; SD = 0.632746; Median 27.000000
 each * represents a count of 1
   26.0000 -    26.6000 [    13]: *************
   26.6000 -    27.2000 [    83]: ***********************************************************************************
   27.2000 -    27.8000 [     0]:
   27.8000 -    28.4000 [     2]: **
   28.4000 -    29.0000 [     0]:
   29.0000 -    29.6000 [     0]:
   29.6000 -    30.2000 [     0]:
   30.2000 -    30.8000 [     0]:
   30.8000 -    31.4000 [     0]:
   31.4000 -    32.0000 [     1]: *


#include <linux/sort.h>
#include <linux/random.h>
#include <linux/ktime.h>
#include <linux/printk.h>
#include <linux/slab.h>
#include <linux/module.h>

#define ARRAY_ELEMENTS 400

static int cmp_32(const void *a, const void *b)
{
	return (int) (*(u32 *)a - *(u32 *)b);
}

static int cmp_64(const void *a, const void *b)
{
	return (int) (*(u64 *)a - *(u64 *)b);
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

static void sort_test(size_t size, void *array)
{
	int (*cmp) (const void *, const void *);
	void (*init)(void *array);
	ktime_t start, stop;
	int i;

	if (size == 4) {
		init = init_array32;
		cmp = cmp_32;
	} else if (size == 8) {
		init = init_array64;
		cmp = cmp_64;
	} else
		return;

	for (i = 0; i < 10000; i++) {
		init(array);

		local_irq_disable();
		start = ktime_get();

		sort(array, ARRAY_ELEMENTS, size, cmp, NULL);

		stop = ktime_get();
		local_irq_enable();

		if (i > 10000 - 100)
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

	pr_info("test u%d_swap\n", (int)size * 8);
	sort_test(size, array);

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

 lib/sort.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN lib/sort.c~lib-sort-add-64-bit-swap-function lib/sort.c
--- a/lib/sort.c~lib-sort-add-64-bit-swap-function
+++ a/lib/sort.c
@@ -15,6 +15,13 @@ static void u32_swap(void *a, void *b, i
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
@@ -50,8 +57,18 @@ void sort(void *base, size_t num, size_t
 	/* pre-scale counters for performance */
 	int i = (num/2 - 1) * size, n = num * size, c, r;
 
-	if (!swap_func)
-		swap_func = (size == 4 ? u32_swap : generic_swap);
+	if (!swap_func) {
+		switch (size) {
+		case 4:
+			swap_func = u32_swap;
+			break;
+		case 8:
+			swap_func = u64_swap;
+			break;
+		default:
+			swap_func = generic_swap;
+		}
+	}
 
 	/* heapify */
 	for ( ; i >= 0; i -= size) {
_

Patches currently in -mm which might be from daniel.wagner@bmw-carit.de are

lib-sort-add-64-bit-swap-function.patch

