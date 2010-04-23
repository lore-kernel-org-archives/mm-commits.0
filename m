From: akpm@linux-foundation.org
Subject: + sdhci-pltfm-implement-platform-data-passing-fix.patch added to -mm tree
Date: Fri, 23 Apr 2010 11:33:09 -0700
Message-ID: <201004231833.o3NIX9Xw004976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319Ab0DWSeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Apr 2010 14:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, ben@simtec.co.uk, david.vrabel@csr.com, linux-mmc@vger.kernel.org, pierre@ossman.eu, richard.rojfors@pelagicore.com


The patch titled
     sdhci-pltfm-implement-platform-data-passing-fix
has been added to the -mm tree.  Its filename is
     sdhci-pltfm-implement-platform-data-passing-fix.patch

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
Subject: sdhci-pltfm-implement-platform-data-passing-fix
=46rom: Anton Vorontsov <avorontsov@mvista.com>

On Wed, Mar 17, 2010 at 07:14:03AM +0100, Richard R=C3=B6jfors wrote:
> On 3/16/10 7:34 PM, Anton Vorontsov wrote:
> > This includes platform ops, quirks and (de)initialization callbacks=
=2E
>
> Good idea, just a doc comment below.
[....]
> > +struct sdhci_pltfm_data {
> > +	struct sdhci_ops *ops;
> > +	unsigned int quirks;
> > +	int (*init)(struct sdhci_host *host);
> > +	void (*exit)(struct sdhci_host *host);
> > +};
>
> I would like to see this struct kernel-doc:ed.

Suggested-by: Richard Rojfors <richard.rojfors@pelagicore.com>
Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sdhci-pltfm.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/sdhci-pltfm.h~sdhci-pltfm-implement-platform-da=
ta-passing-fix include/linux/sdhci-pltfm.h
--- a/include/linux/sdhci-pltfm.h~sdhci-pltfm-implement-platform-data-p=
assing-fix
+++ a/include/linux/sdhci-pltfm.h
@@ -17,6 +17,14 @@
 struct sdhci_ops;
 struct sdhci_host;
=20
+/**
+ * struct sdhci_pltfm_data - SDHCI platform-specific information & hoo=
ks
+ * @ops: optional pointer to the platform-provided SDHCI ops
+ * @quirks: optional SDHCI quirks
+ * @init: optional hook that is called during device probe, before the
+ *        driver tries to access any SDHCI registers
+ * @exit: optional hook that is called during device removal
+ */
 struct sdhci_pltfm_data {
 	struct sdhci_ops *ops;
 	unsigned int quirks;
_

Patches currently in -mm which might be from avorontsov@mvista.com are

sdhci-pltfm-implement-platform-data-passing-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
