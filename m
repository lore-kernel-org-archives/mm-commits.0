From: akpm@osdl.org
Subject: + edac-add-memory-scrubbing-controls-api-to-core.patch added to -mm tree
Date: Thu, 14 Dec 2006 12:55:02 -0800
Message-ID: <200612142055.kBEKt4lq024339@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57082 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909AbWLNUzR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 15:55:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: frithiof.jensen@ericson.com, alan@redhat.com, norsk5@xmission.com


The patch titled
     EDAC: Add memory scrubbing controls API to core
has been added to the -mm tree.  Its filename is
     edac-add-memory-scrubbing-controls-api-to-core.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: EDAC: Add memory scrubbing controls API to core
From: Frithiof Jensen <frithiof.jensen@ericson.com>

This is an attempt of providing an interface for memory scrubbing control in
EDAC.

This patch modifies the EDAC Core to provide the Interface for memory
controller modules to implment.

The following things are still outstanding:

 - K8 is the first implemenation,

   The patch provide a method of configuring the K8 hardware memory scrubber
   via the 'mcX' sysfs directory.  There should be some fallback to a generic
   scrubber implemented in software if the hardware does not support
   scrubbing.

   Or .. the scrubbing sysfs entry should not be visible at all.

 - Only works with SDRAM, not cache,

   The K8 can scrub cache and l2cache also - but I think this is not so
   useful as the cache is busy all the time (one hopes).

   One would also expect that cache scrubbing requires hardware support.

 - Error Handling,

   I would like that errors are returned to the user in "terms of file
   system".

 - Presentation,

   I chose Bandwidth in Bytes/Second as a representation of the scrubbing
   rate for the following reasons:

   I like that the sysfs entries are sort-of textual, related to something
   that makes sense instead of magical values that must be looked up.

   "My People" wants "% main memory scrubbed per hour" others prefer "%
   memory bandwidth used" as representation, "bandwith used" makes it easy to
   calculate both versions in one-liner scripts.

   If one later wants to scrub cache, the scaling becomes wierd for K8
   changing from "blocks of 64 byte memory" to "blocks of 64 cache lines" to
   "blocks of 64 bit".  Using "bandwidth used" makes sense in all three cases,
   (I.M.O.  anyway ;-).

 - Discovery,

   There is no way to discover the possible settings and what they do
   without reading the code and the documentation.

   *I* do not know how to make that work in a practical way.

 - Bugs(??),

   other tools can set invalid values in the memory scrub control register,
   those will read back as '-1', requiring the user to reset the scrub rate. 
   This is how *I* think it should be.

 - Afflicting other areas of code,

   I made changes to edac_mc.c and edac_mc.h which will show up globally -
   this is not nice, it would be better that the memory scrubbing fuctionality
   and interface could be entirely contained within the memory controller it
   applies to.

Frithiof Jensen

edac_mc.c and its .h file is a CORE helper module for EDAC
driver modules. This provides the abstraction for device specific
drivers. It is fine to modify this CORE to provide help for
new features of the the drivers

doug thompson

Signed-off-by: Frithiof Jensen <frithiof.jensen@ericson.com>
Signed-off-by: doug thompson <norsk5@xmission.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/drivers/edac/edac.txt |   16 +++++++
 drivers/edac/edac_mc.c              |   55 ++++++++++++++++++++++++++
 drivers/edac/edac_mc.h              |   12 +++++
 3 files changed, 82 insertions(+), 1 deletion(-)

diff -puN Documentation/drivers/edac/edac.txt~edac-add-memory-scrubbing-controls-api-to-core Documentation/drivers/edac/edac.txt
--- a/Documentation/drivers/edac/edac.txt~edac-add-memory-scrubbing-controls-api-to-core
+++ a/Documentation/drivers/edac/edac.txt
@@ -339,7 +339,21 @@ Device Symlink:
 
 	'device'
 
-	Symlink to the memory controller device
+	Symlink to the memory controller device.
+
+Sdram memory scrubbing rate:
+
+	'sdram_scrub_rate'
+
+	Read/Write attribute file that controls memory scrubbing. The scrubbing
+	rate is set by writing a minimum bandwith in bytes/sec to the attribute
+	file. The rate will be translated to an internal value that gives at
+	least the specified rate.
+
+	Reading the file will return the actual scrubbing rate employed.
+
+	If configuration fails or memory scrubbing is not implemented, the value
+	of the attribute file will be -1.
 
 
 
diff -puN drivers/edac/edac_mc.c~edac-add-memory-scrubbing-controls-api-to-core drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~edac-add-memory-scrubbing-controls-api-to-core
+++ a/drivers/edac/edac_mc.c
@@ -927,6 +927,57 @@ static ssize_t mci_reset_counters_store(
 	return count;
 }
 
+/* memory scrubbing */
+static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
+					const char *data, size_t count)
+{
+	u32 bandwidth = -1;
+
+	if (mci->set_sdram_scrub_rate) {
+
+		memctrl_int_store(&bandwidth, data, count);
+
+		if (!(*mci->set_sdram_scrub_rate)(mci, &bandwidth)) {
+			edac_printk(KERN_DEBUG, EDAC_MC,
+				"Scrub rate set successfully, applied: %d\n",
+				bandwidth);
+		} else {
+			/* FIXME: error codes maybe? */
+			edac_printk(KERN_DEBUG, EDAC_MC,
+				"Scrub rate set FAILED, could not apply: %d\n",
+				bandwidth);
+		}
+	} else {
+		/* FIXME: produce "not implemented" ERROR for user-side. */
+		edac_printk(KERN_WARNING, EDAC_MC,
+			"Memory scrubbing 'set'control is not implemented!\n");
+	}
+	return count;
+}
+
+static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
+{
+	u32 bandwidth = -1;
+
+	if (mci->get_sdram_scrub_rate) {
+		if (!(*mci->get_sdram_scrub_rate)(mci, &bandwidth)) {
+			edac_printk(KERN_DEBUG, EDAC_MC,
+				"Scrub rate successfully, fetched: %d\n",
+				bandwidth);
+		} else {
+			/* FIXME: error codes maybe? */
+			edac_printk(KERN_DEBUG, EDAC_MC,
+				"Scrub rate fetch FAILED, got: %d\n",
+				bandwidth);
+		}
+	} else {
+		/* FIXME: produce "not implemented" ERROR for user-side.  */
+		edac_printk(KERN_WARNING, EDAC_MC,
+			"Memory scrubbing 'get' control is not implemented!\n");
+	}
+	return sprintf(data, "%d\n", bandwidth);
+}
+
 /* default attribute files for the MCI object */
 static ssize_t mci_ue_count_show(struct mem_ctl_info *mci, char *data)
 {
@@ -1033,6 +1084,9 @@ MCIDEV_ATTR(ce_noinfo_count,S_IRUGO,mci_
 MCIDEV_ATTR(ue_count,S_IRUGO,mci_ue_count_show,NULL);
 MCIDEV_ATTR(ce_count,S_IRUGO,mci_ce_count_show,NULL);
 
+/* memory scrubber attribute file */
+MCIDEV_ATTR(sdram_scrub_rate,S_IRUGO|S_IWUSR,mci_sdram_scrub_rate_show,mci_sdram_scrub_rate_store);
+
 static struct mcidev_attribute *mci_attr[] = {
 	&mci_attr_reset_counters,
 	&mci_attr_mc_name,
@@ -1042,6 +1096,7 @@ static struct mcidev_attribute *mci_attr
 	&mci_attr_ce_noinfo_count,
 	&mci_attr_ue_count,
 	&mci_attr_ce_count,
+	&mci_attr_sdram_scrub_rate,
 	NULL
 };
 
diff -puN drivers/edac/edac_mc.h~edac-add-memory-scrubbing-controls-api-to-core drivers/edac/edac_mc.h
--- a/drivers/edac/edac_mc.h~edac-add-memory-scrubbing-controls-api-to-core
+++ a/drivers/edac/edac_mc.h
@@ -315,6 +315,18 @@ struct mem_ctl_info {
 	unsigned long scrub_cap;	/* chipset scrub capabilities */
 	enum scrub_type scrub_mode;	/* current scrub mode */
 
+	/* Translates sdram memory scrub rate given in bytes/sec to the
+	   internal representation and configures whatever else needs
+	   to be configured.
+	*/
+	int (*set_sdram_scrub_rate) (struct mem_ctl_info *mci, u32 *bw);
+
+	/* Get the current sdram memory scrub rate from the internal
+	   representation and converts it to the closest matching
+	   bandwith in bytes/sec.
+	*/
+	int (*get_sdram_scrub_rate) (struct mem_ctl_info *mci, u32 *bw);
+
 	/* pointer to edac checking routine */
 	void (*edac_check) (struct mem_ctl_info * mci);
 	/*
_

Patches currently in -mm which might be from frithiof.jensen@ericson.com are

edac-add-memory-scrubbing-controls-api-to-core.patch

