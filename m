From: akpm@linux-foundation.org
Subject: + drivers-acpi-apei-einjc-allow-empty-trigger-error-action-table.patch added to -mm tree
Date: Fri, 13 Jan 2012 16:10:12 -0800
Message-ID: <20120114001013.0E4232000AC@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42860 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2ANAKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 19:10:15 -0500
Received: by eaad12 with SMTP id d12so29971eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 16:10:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: niklas.soderlund@ericsson.com, lenb@kernel.org, ying.huang@intel.com


The patch titled
     Subject: drivers/acpi/apei/einj.c: allow empty Trigger Error Actio=
n Table
has been added to the -mm tree.  Its filename is
     drivers-acpi-apei-einjc-allow-empty-trigger-error-action-table.pat=
ch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Niklas S=F6derlund <niklas.soderlund@ericsson.com>
Subject: drivers/acpi/apei/einj.c: allow empty Trigger Error Action Tab=
le

When troubleshooting some BIOS code I encounter strange errors about
firmware bugs.  On closer inspection I found that the Trigger table
returned from the firmware was empty but the header looked OK:

header_size =3D 16
table_size =3D 16
entry_count =3D 0

When looking at einj.c I found that this header would result in the err=
or
I was receiving.  I took a quick look at the docs and from what I can t=
ell
this is a valid header, yes?

According to the ACPI spec [1] section 18.6.4 the TRIGGER_ERROR action
table can consists of zero elements.

[1] Advanced Configuration and Power Interface Specification
    Revision 5.0, December 6, 2011
	http://www.acpi.info/DOWNLOADS/ACPIspec50.pdf

Signed-off-by: Niklas S=F6derlund <niklas.soderlund@ericsson.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/apei/einj.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/apei/einj.c~drivers-acpi-apei-einjc-allow-empty-=
trigger-error-action-table drivers/acpi/apei/einj.c
--- a/drivers/acpi/apei/einj.c~drivers-acpi-apei-einjc-allow-empty-trig=
ger-error-action-table
+++ a/drivers/acpi/apei/einj.c
@@ -184,7 +184,7 @@ static int einj_check_trigger_header(str
 	if (trigger_tab->header_size !=3D sizeof(struct acpi_einj_trigger))
 		return -EINVAL;
 	if (trigger_tab->table_size > PAGE_SIZE ||
-	    trigger_tab->table_size <=3D trigger_tab->header_size)
+	    trigger_tab->table_size < trigger_tab->header_size)
 		return -EINVAL;
 	if (trigger_tab->entry_count !=3D
 	    (trigger_tab->table_size - trigger_tab->header_size) /
@@ -225,6 +225,11 @@ static int __einj_error_trigger(u64 trig
 			   "The trigger error action table is invalid\n");
 		goto out_rel_header;
 	}
+
+	/* No action structures in the TRIGGER_ERROR table, nothing to do */
+	if (!trigger_tab->entry_count)
+		goto out_rel_header;
+
 	rc =3D -EIO;
 	table_size =3D trigger_tab->table_size;
 	r =3D request_mem_region(trigger_paddr + sizeof(*trigger_tab),
_
Subject: Subject: drivers/acpi/apei/einj.c: allow empty Trigger Error A=
ction Table

Patches currently in -mm which might be from niklas.soderlund@ericsson.=
com are

linux-next.patch
drivers-acpi-apei-einjc-allow-empty-trigger-error-action-table.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
