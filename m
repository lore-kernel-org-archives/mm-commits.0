From: akpm@linux-foundation.org
Subject: + iio-documentation-add-iio-configfs-documentation.patch added to -mm tree
Date: Tue, 10 Nov 2015 13:10:07 -0800
Message-ID: <56425d2f.U0/4ykbi52a8srR5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbKJVKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 16:10:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.baluta@intel.com, adriana.reus@intel.com, cmo@melexis.com, cristina.opriceana@gmail.com, hch@lst.de, jlbec@evilplan.org, knaack.h@gmx.de, lars@metafoo.de, octavian.purdila@intel.com, pebolle@tiscali.nl, pmeerw@pmeerw.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: iio: Documentation: add IIO configfs documentation
has been added to the -mm tree.  Its filename is
     iio-documentation-add-iio-configfs-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/iio-documentation-add-iio-configfs-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/iio-documentation-add-iio-configfs-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Baluta <daniel.baluta@intel.com>
Subject: iio: Documentation: add IIO configfs documentation

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Acked-by: Crt Mori <cmo@melexis.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Adriana Reus <adriana.reus@intel.com>
Cc: Daniel Baluta <daniel.baluta@intel.com>
Cc: Cristina Opriceana <cristina.opriceana@gmail.com>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/configfs-iio |   21 +++++
 Documentation/iio/iio_configfs.txt     |   93 +++++++++++++++++++++++
 2 files changed, 114 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/configfs-iio
--- /dev/null
+++ a/Documentation/ABI/testing/configfs-iio
@@ -0,0 +1,21 @@
+What:		/config/iio
+Date:		October 2015
+KernelVersion:	4.4
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This represents Industrial IO configuration entry point
+		directory. It contains sub-groups corresponding to IIO
+		objects.
+
+What:		/config/iio/triggers
+Date:		October 2015
+KernelVersion:	4.4
+Description:
+		Industrial IO software triggers directory.
+
+What:		/config/iio/triggers/hrtimers
+Date:		October 2015
+KernelVersion:	4.4
+Description:
+		High resolution timers directory. Creating a directory here
+		will result in creating a hrtimer trigger in the IIO subsystem.
diff -puN /dev/null Documentation/iio/iio_configfs.txt
--- /dev/null
+++ a/Documentation/iio/iio_configfs.txt
@@ -0,0 +1,93 @@
+Industrial IIO configfs support
+
+1. Overview
+
+Configfs is a filesystem-based manager of kernel objects. IIO uses some
+objects that could be easily configured using configfs (e.g.: devices,
+triggers).
+
+See Documentation/filesystems/configfs/configfs.txt for more information
+about how configfs works.
+
+2. Usage
+
+In order to use configfs support in IIO we need to select it at compile
+time via CONFIG_IIO_CONFIGFS config option.
+
+Then, mount the configfs filesystem (usually under /config directory):
+
+$ mkdir /config
+$ mount -t configfs none /config
+
+At this point, all default IIO groups will be created and can be accessed
+under /config/iio. Next chapters will describe available IIO configuration
+objects.
+
+3. Software triggers
+
+One of the IIO default configfs groups is the "triggers" group. It is
+automagically accessible when the configfs is mounted and can be found
+under /config/iio/triggers.
+
+IIO software triggers implementation offers support for creating multiple
+trigger types. A new trigger type is usually implemented as a separate
+kernel module following the interface in include/linux/iio/sw_trigger.h:
+
+/*
+ * drivers/iio/trigger/iio-trig-sample.c
+ * sample kernel module implementing a new trigger type
+ */
+#include <linux/iio/sw_trigger.h>
+
+
+static struct iio_sw_trigger *iio_trig_sample_probe(const char *name)
+{
+	/*
+	 * This allocates and registers an IIO trigger plus other
+	 * trigger type specific initialization.
+	 */
+}
+
+static int iio_trig_hrtimer_remove(struct iio_sw_trigger *swt)
+{
+	/*
+	 * This undoes the actions in iio_trig_sample_probe
+	 */
+}
+
+static const struct iio_sw_trigger_ops iio_trig_sample_ops = {
+	.probe		= iio_trig_sample_probe,
+	.remove		= iio_trig_sample_remove,
+};
+
+static struct iio_sw_trigger_type iio_trig_sample = {
+	.name = "trig-sample",
+	.owner = THIS_MODULE,
+	.ops = &iio_trig_sample_ops,
+};
+
+module_iio_sw_trigger_driver(iio_trig_sample);
+
+Each trigger type has its own directory under /config/iio/triggers. Loading
+iio-trig-sample module will create 'trig-sample' trigger type directory
+/config/iio/triggers/trig-sample.
+
+We support the following interrupt sources (trigger types):
+	* hrtimer, uses high resolution timers as interrupt source
+
+3.1 Hrtimer triggers creation and destruction
+
+Loading iio-trig-hrtimer module will register hrtimer trigger types allowing
+users to create hrtimer triggers under /config/iio/triggers/hrtimer.
+
+e.g:
+
+$ mkdir /config/triggers/hrtimer/instance1
+$ rmdir /config/triggers/hrtimer/instance1
+
+Each trigger can have one or more attributes specific to the trigger type.
+
+3.2 "hrtimer" trigger types attributes
+
+"hrtimer" trigger type doesn't have any configurable attribute from /config dir.
+It does introduce the sampling_frequency attribute to trigger directory.
_

Patches currently in -mm which might be from daniel.baluta@intel.com are

configfs-allow-dynamic-group-creation.patch
iio-core-introduce-iio-configfs-support.patch
iio-core-introduce-iio-software-triggers.patch
iio-trigger-introduce-iio-hrtimer-based-trigger.patch
iio-documentation-add-iio-configfs-documentation.patch

