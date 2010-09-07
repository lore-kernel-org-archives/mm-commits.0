From: akpm@linux-foundation.org
Subject: + mmc_test-collect-data-and-show-it-via-sysfs-by-demand.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:30:05 -0700
Message-ID: <201009072230.o87MU5rJ010213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436Ab0IGWaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:30:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy.shevchenko@gmail.com, ext-andriy.shevchenko@nokia.com, linux-mmc@vger.kernel.org


The patch titled
     mmc_test: collect data and show it via sysfs by demand
has been added to the -mm tree.  Its filename is
     mmc_test-collect-data-and-show-it-via-sysfs-by-demand.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_test: collect data and show it via sysfs by demand
From: Andy Shevchenko <andy.shevchenko@gmail.com>

Make it possibile to get test results via sysfs.  It helps to do tests
non-interactively.

We have the file created under sysfs already and we could use it to out test
results.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/mmc_test.c |  171 +++++++++++++++++++++++++++++++++-
 1 file changed, 169 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/card/mmc_test.c~mmc_test-collect-data-and-show-it-via-sysfs-by-demand drivers/mmc/card/mmc_test.c
--- a/drivers/mmc/card/mmc_test.c~mmc_test-collect-data-and-show-it-via-sysfs-by-demand
+++ a/drivers/mmc/card/mmc_test.c
@@ -17,6 +17,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/swap.h>		/* For nr_free_buffer_pages() */
+#include <linux/list.h>
 
 #define RESULT_OK		0
 #define RESULT_FAIL		1
@@ -73,12 +74,45 @@ struct mmc_test_area {
 };
 
 /**
+ * struct mmc_test_transfer_result - transfer results for performance tests.
+ * @link: double-linked list
+ * @count: amount of group of sectors to check
+ * @sectors: amount of sectors to check in one group
+ * @ts: time values of transfer
+ * @rate: calculated transfer rate
+ */
+struct mmc_test_transfer_result {
+	struct list_head link;
+	unsigned int count;
+	unsigned int sectors;
+	struct timespec ts;
+	unsigned int rate;
+};
+
+/**
+ * struct mmc_test_general_result - results for tests.
+ * @link: double-linked list
+ * @card: card under test
+ * @testcase: number of test case
+ * @result: result of test run
+ * @tr_lst: transfer measurements if any as mmc_test_transfer_result
+ */
+struct mmc_test_general_result {
+	struct list_head link;
+	struct mmc_card *card;
+	int testcase;
+	int result;
+	struct list_head tr_lst;
+};
+
+/**
  * struct mmc_test_card - test information.
  * @card: card under test
  * @scratch: transfer buffer
  * @buffer: transfer buffer
  * @highmem: buffer for highmem tests
  * @area: information for performance tests
+ * @gr: pointer to results of current testcase
  */
 struct mmc_test_card {
 	struct mmc_card	*card;
@@ -88,7 +122,8 @@ struct mmc_test_card {
 #ifdef CONFIG_HIGHMEM
 	struct page	*highmem;
 #endif
-	struct mmc_test_area area;
+	struct mmc_test_area		area;
+	struct mmc_test_general_result	*gr;
 };
 
 /*******************************************************************/
@@ -421,6 +456,30 @@ static unsigned int mmc_test_rate(uint64
 }
 
 /*
+ * Save transfer results for future usage
+ */
+static void mmc_test_save_transfer_result(struct mmc_test_card *test,
+	unsigned int count, unsigned int sectors, struct timespec ts,
+	unsigned int rate)
+{
+	struct mmc_test_transfer_result *tr;
+
+	if (!test->gr)
+		return;
+
+	tr = kmalloc(sizeof(struct mmc_test_transfer_result), GFP_KERNEL);
+	if (!tr)
+		return;
+
+	tr->count = count;
+	tr->sectors = sectors;
+	tr->ts = ts;
+	tr->rate = rate;
+
+	list_add_tail(&tr->link, &test->gr->tr_lst);
+}
+
+/*
  * Print the transfer rate.
  */
 static void mmc_test_print_rate(struct mmc_test_card *test, uint64_t bytes,
@@ -438,6 +497,8 @@ static void mmc_test_print_rate(struct m
 			 mmc_hostname(test->card->host), sectors, sectors >> 1,
 			 (sectors == 1 ? ".5" : ""), (unsigned long)ts.tv_sec,
 			 (unsigned long)ts.tv_nsec, rate / 1000, rate / 1024);
+
+	mmc_test_save_transfer_result(test, 1, sectors, ts, rate);
 }
 
 /*
@@ -461,6 +522,8 @@ static void mmc_test_print_avg_rate(stru
 			 sectors >> 1, (sectors == 1 ? ".5" : ""),
 			 (unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec,
 			 rate / 1000, rate / 1024);
+
+	mmc_test_save_transfer_result(test, count, sectors, ts, rate);
 }
 
 /*
@@ -1853,6 +1916,8 @@ static const struct mmc_test_case mmc_te
 
 static DEFINE_MUTEX(mmc_test_lock);
 
+static LIST_HEAD(mmc_test_result);
+
 static void mmc_test_run(struct mmc_test_card *test, int testcase)
 {
 	int i, ret;
@@ -1863,6 +1928,8 @@ static void mmc_test_run(struct mmc_test
 	mmc_claim_host(test->card->host);
 
 	for (i = 0;i < ARRAY_SIZE(mmc_test_cases);i++) {
+		struct mmc_test_general_result *gr;
+
 		if (testcase && ((i + 1) != testcase))
 			continue;
 
@@ -1881,6 +1948,25 @@ static void mmc_test_run(struct mmc_test
 			}
 		}
 
+		gr = kzalloc(sizeof(struct mmc_test_general_result),
+			GFP_KERNEL);
+		if (gr) {
+			INIT_LIST_HEAD(&gr->tr_lst);
+
+			/* Assign data what we know already */
+			gr->card = test->card;
+			gr->testcase = i;
+
+			/* Append container to global one */
+			list_add_tail(&gr->link, &mmc_test_result);
+
+			/*
+			 * Save the pointer to created container in our private
+			 * structure.
+			 */
+			test->gr = gr;
+		}
+
 		ret = mmc_test_cases[i].run(test);
 		switch (ret) {
 		case RESULT_OK:
@@ -1906,6 +1992,10 @@ static void mmc_test_run(struct mmc_test
 				mmc_hostname(test->card->host), ret);
 		}
 
+		/* Save the result */
+		if (gr)
+			gr->result = ret;
+
 		if (mmc_test_cases[i].cleanup) {
 			ret = mmc_test_cases[i].cleanup(test);
 			if (ret) {
@@ -1923,13 +2013,80 @@ static void mmc_test_run(struct mmc_test
 		mmc_hostname(test->card->host));
 }
 
+static void mmc_test_free_result(struct mmc_card *card)
+{
+	struct mmc_test_general_result *gr, *grs;
+
+	mutex_lock(&mmc_test_lock);
+
+	list_for_each_entry_safe(gr, grs, &mmc_test_result, link) {
+		struct mmc_test_transfer_result *tr, *trs;
+
+		if (card && gr->card != card)
+			continue;
+
+		list_for_each_entry_safe(tr, trs, &gr->tr_lst, link) {
+			list_del(&tr->link);
+			kfree(tr);
+		}
+
+		list_del(&gr->link);
+		kfree(gr);
+	}
+
+	mutex_unlock(&mmc_test_lock);
+}
+
 static ssize_t mmc_test_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
+	struct mmc_card *card = mmc_dev_to_card(dev);
+	struct mmc_test_general_result *gr;
+	char *p = buf;
+	size_t len = PAGE_SIZE;
+	int ret;
+
 	mutex_lock(&mmc_test_lock);
+
+	list_for_each_entry(gr, &mmc_test_result, link) {
+		struct mmc_test_transfer_result *tr;
+
+		if (gr->card != card)
+			continue;
+
+		ret = snprintf(p, len, "Test %d: %d\n", gr->testcase + 1,
+			gr->result);
+		if (ret < 0)
+			goto err;
+		if (ret >= len) {
+			ret = -ENOBUFS;
+			goto err;
+		}
+		p += ret;
+		len -= ret;
+
+		list_for_each_entry(tr, &gr->tr_lst, link) {
+			ret = snprintf(p, len, "%u %d %lu.%09lu %u\n",
+				tr->count, tr->sectors,
+				(unsigned long)tr->ts.tv_sec,
+				(unsigned long)tr->ts.tv_nsec,
+				tr->rate);
+			if (ret < 0)
+				goto err;
+			if (ret >= len) {
+				ret = -ENOBUFS;
+				goto err;
+			}
+			p += ret;
+			len -= ret;
+		}
+	}
+
+	ret = PAGE_SIZE - len;
+err:
 	mutex_unlock(&mmc_test_lock);
 
-	return 0;
+	return ret;
 }
 
 static ssize_t mmc_test_store(struct device *dev,
@@ -1946,6 +2103,12 @@ static ssize_t mmc_test_store(struct dev
 	if (!test)
 		return -ENOMEM;
 
+	/*
+	 * Remove all test cases associated with given card. Thus we have only
+	 * actual data of the last run.
+	 */
+	mmc_test_free_result(card);
+
 	test->card = card;
 
 	test->buffer = kzalloc(BUFFER_SIZE, GFP_KERNEL);
@@ -1992,6 +2155,7 @@ static int mmc_test_probe(struct mmc_car
 
 static void mmc_test_remove(struct mmc_card *card)
 {
+	mmc_test_free_result(card);
 	device_remove_file(&card->dev, &dev_attr_test);
 }
 
@@ -2010,6 +2174,9 @@ static int __init mmc_test_init(void)
 
 static void __exit mmc_test_exit(void)
 {
+	/* Clear stalled data if card is still plugged */
+	mmc_test_free_result(NULL);
+
 	mmc_unregister_driver(&mmc_driver);
 }
 
_

Patches currently in -mm which might be from andy.shevchenko@gmail.com are

linux-next.patch
lib-bitmapc-use-hex_to_bin.patch
mmc-make-dev_to_mmc_card-macro-public.patch
mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card.patch
mmc_test-use-api-to-check-card-type.patch
mmc_test-change-simple_strtol-to-strict_strtol.patch
mmc_test-collect-data-and-show-it-via-sysfs-by-demand.patch

