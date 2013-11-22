From: akpm@linux-foundation.org
Subject: + mm-add-strictlimit-knob-v2.patch added to -mm tree
Date: Fri, 22 Nov 2013 15:47:49 -0800
Message-ID: <528fed25.1a6H3FNOhMajLSxv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab3KVXru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 18:47:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, t.artem@lycos.com, mel@csn.ul.ie, jack@suse.cz, hmh@hmh.eng.br, fengguang.wu@intel.com, MPatlasov@parallels.com

Subject: + mm-add-strictlimit-knob-v2.patch added to -mm tree
To: MPatlasov@parallels.com,fengguang.wu@intel.com,hmh@hmh.eng.br,jack@suse.cz,mel@csn.ul.ie,t.artem@lycos.com,tytso@mit.edu
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 15:47:49 -0800


The patch titled
     Subject: mm: add strictlimit knob
has been added to the -mm tree.  Its filename is
     mm-add-strictlimit-knob-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-strictlimit-knob-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-strictlimit-knob-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maxim Patlasov <MPatlasov@parallels.com>
Subject: mm: add strictlimit knob

The "strictlimit" feature was introduced to enforce per-bdi dirty limits
for FUSE which sets bdi max_ratio to 1% by default:

http://article.gmane.org/gmane.linux.kernel.mm/105809

However the feature can be useful for other relatively slow or untrusted
BDIs like USB flash drives and DVD+RW.  The patch adds a knob to enable
the feature:

echo 1 > /sys/class/bdi/X:Y/strictlimit

Being enabled, the feature enforces bdi max_ratio limit even if global
(10%) dirty limit is not reached.  Of course, the effect is not visible
until /sys/class/bdi/X:Y/max_ratio is decreased to some reasonable value.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |    8 ++++
 mm/backing-dev.c                          |   35 ++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff -puN Documentation/ABI/testing/sysfs-class-bdi~mm-add-strictlimit-knob-v2 Documentation/ABI/testing/sysfs-class-bdi
--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-add-strictlimit-knob-v2
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -53,3 +53,11 @@ stable_pages_required (read-only)
 
 	If set, the backing device requires that all pages comprising a write
 	request must not be changed until writeout is complete.
+
+strictlimit (read-write)
+
+	Forces per-BDI checks for the share of given device in the write-back
+	cache even before the global background dirty limit is reached. This
+	is useful in situations where the global limit is much higher than
+	affordable for given relatively slow (or untrusted) device. Turning
+	strictlimit on has no visible effect if max_ratio is equal to 100%.
diff -puN mm/backing-dev.c~mm-add-strictlimit-knob-v2 mm/backing-dev.c
--- a/mm/backing-dev.c~mm-add-strictlimit-knob-v2
+++ a/mm/backing-dev.c
@@ -234,11 +234,46 @@ static ssize_t stable_pages_required_sho
 }
 static DEVICE_ATTR_RO(stable_pages_required);
 
+static ssize_t strictlimit_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	unsigned int val;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	switch (val) {
+	case 0:
+		bdi->capabilities &= ~BDI_CAP_STRICTLIMIT;
+		break;
+	case 1:
+		bdi->capabilities |= BDI_CAP_STRICTLIMIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return count;
+}
+static ssize_t strictlimit_show(struct device *dev,
+		struct device_attribute *attr, char *page)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n",
+			!!(bdi->capabilities & BDI_CAP_STRICTLIMIT));
+}
+static DEVICE_ATTR_RW(strictlimit);
+
 static struct attribute *bdi_dev_attrs[] = {
 	&dev_attr_read_ahead_kb.attr,
 	&dev_attr_min_ratio.attr,
 	&dev_attr_max_ratio.attr,
 	&dev_attr_stable_pages_required.attr,
+	&dev_attr_strictlimit.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(bdi_dev);
_

Patches currently in -mm which might be from MPatlasov@parallels.com are

origin.patch
mm-add-strictlimit-knob-v2.patch

