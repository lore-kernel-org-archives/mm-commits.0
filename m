From: akpm@linux-foundation.org
Subject: - drivers-add-lcd-support-update6.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:10:31 -0800
Message-ID: <200702100810.l1A8AVo3006941@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39265 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbXBJIKd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:10:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers: add LCD support (update 6)
has been removed from the -mm tree.  Its filename was
     drivers-add-lcd-support-update6.patch

This patch was dropped because it was folded into drivers-add-lcd-support-3.patch

------------------------------------------------------
Subject: drivers: add LCD support (update 6)
From: Miguel Ojeda Sandonis <maxextreme@gmail.com>

- Minor coding style fixes

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/auxdisplay/cfag12864b-example.c |    4 ++--
 drivers/auxdisplay/cfag12864b.c               |    4 ++--
 drivers/auxdisplay/cfag12864bfb.c             |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN Documentation/auxdisplay/cfag12864b-example.c~drivers-add-lcd-support-update6 Documentation/auxdisplay/cfag12864b-example.c
--- a/Documentation/auxdisplay/cfag12864b-example.c~drivers-add-lcd-support-update6
+++ a/Documentation/auxdisplay/cfag12864b-example.c
@@ -203,7 +203,7 @@ void example(unsigned char n)
 	unsigned short i, j;
 	unsigned char matrix[CFAG12864B_WIDTH * CFAG12864B_HEIGHT];
 
-	if(n > EXAMPLES)
+	if (n > EXAMPLES)
 		return;
 
 	printf("Example %i/%i - ", n, EXAMPLES);
@@ -273,7 +273,7 @@ int main(int argc, char *argv[])
 	for (n = 1; n <= EXAMPLES; n++) {
 		example(n);
 		cfag12864b_blit();
-		while(getchar() != '\n');
+		while (getchar() != '\n');
 	}
 
 	cfag12864b_exit();
diff -puN drivers/auxdisplay/cfag12864b.c~drivers-add-lcd-support-update6 drivers/auxdisplay/cfag12864b.c
--- a/drivers/auxdisplay/cfag12864b.c~drivers-add-lcd-support-update6
+++ a/drivers/auxdisplay/cfag12864b.c
@@ -237,7 +237,7 @@ unsigned char cfag12864b_enable(void)
 
 	mutex_lock(&cfag12864b_mutex);
 
-	if(!cfag12864b_updating) {
+	if (!cfag12864b_updating) {
 		cfag12864b_updating = 1;
 		cfag12864b_queue();
 		ret = 0;
@@ -254,7 +254,7 @@ void cfag12864b_disable(void)
 {
 	mutex_lock(&cfag12864b_mutex);
 
-	if(cfag12864b_updating) {
+	if (cfag12864b_updating) {
 		cfag12864b_updating = 0;
 		cancel_delayed_work(&cfag12864b_work);
 		flush_workqueue(cfag12864b_workqueue);
diff -puN drivers/auxdisplay/cfag12864bfb.c~drivers-add-lcd-support-update6 drivers/auxdisplay/cfag12864bfb.c
--- a/drivers/auxdisplay/cfag12864bfb.c~drivers-add-lcd-support-update6
+++ a/drivers/auxdisplay/cfag12864bfb.c
@@ -71,7 +71,7 @@ static struct page *cfag12864bfb_vma_nop
 	struct page *page = virt_to_page(cfag12864b_buffer);
 	get_page(page);
 
-	if(type)
+	if (type)
 		*type = VM_FAULT_MINOR;
 
 	return page;
@@ -156,7 +156,7 @@ static int __init cfag12864bfb_init(void
 {
 	int ret;
 
-	if(cfag12864b_enable()) {
+	if (cfag12864b_enable()) {
 		printk(KERN_ERR CFAG12864BFB_NAME ": ERROR: "
 			"can't enable cfag12864b refreshing (being used)\n");
 		return -ENODEV;
_

Patches currently in -mm which might be from maxextreme@gmail.com are

drivers-add-lcd-support-3.patch
drivers-add-lcd-support-update6.patch
drivers-add-lcd-support-update-7.patch
drivers-add-lcd-support-update-8.patch
drivers-add-lcd-support-update-9.patch
drivers-add-lcd-support-workqueue-fixups.patch
