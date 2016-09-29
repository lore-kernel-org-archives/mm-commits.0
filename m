From: akpm@linux-foundation.org
Subject: + ima-on-soft-reboot-restore-the-measurement-list.patch added to
 -mm tree
Date: Thu, 29 Sep 2016 16:15:08 -0700
Message-ID: <57eda07c.sJxuP7KPdTBPQlxc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50140 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935086AbcI2XPK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2016 19:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, dyoung@redhat.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima: on soft reboot, restore the measurement list
has been added to the -mm tree.  Its filename is
     ima-on-soft-reboot-restore-the-measurement-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-on-soft-reboot-restore-the-measurement-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-on-soft-reboot-restore-the-measurement-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: ima: on soft reboot, restore the measurement list

The TPM PCRs are only reset on a hard reboot.  In order to validate a
TPM's quote after a soft reboot (eg. kexec -e), the IMA measurement list
of the running kernel must be saved and restored on boot.  This patch
restores the measurement list.

Link: http://lkml.kernel.org/r/1474911029-6372-3-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/Makefile       |    1 
 security/integrity/ima/ima.h          |   21 ++
 security/integrity/ima/ima_init.c     |    2 
 security/integrity/ima/ima_kexec.c    |   44 ++++++
 security/integrity/ima/ima_queue.c    |   10 +
 security/integrity/ima/ima_template.c |  170 ++++++++++++++++++++++++
 6 files changed, 248 insertions(+)

diff -puN security/integrity/ima/Makefile~ima-on-soft-reboot-restore-the-measurement-list security/integrity/ima/Makefile
--- a/security/integrity/ima/Makefile~ima-on-soft-reboot-restore-the-measurement-list
+++ a/security/integrity/ima/Makefile
@@ -8,4 +8,5 @@ obj-$(CONFIG_IMA) += ima.o
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
 	 ima_policy.o ima_template.o ima_template_lib.o
 ima-$(CONFIG_IMA_APPRAISE) += ima_appraise.o
+ima-$(CONFIG_HAVE_IMA_KEXEC) += ima_kexec.o
 obj-$(CONFIG_IMA_BLACKLIST_KEYRING) += ima_mok.o
diff -puN security/integrity/ima/ima.h~ima-on-soft-reboot-restore-the-measurement-list security/integrity/ima/ima.h
--- a/security/integrity/ima/ima.h~ima-on-soft-reboot-restore-the-measurement-list
+++ a/security/integrity/ima/ima.h
@@ -28,6 +28,10 @@
 
 #include "../integrity.h"
 
+#ifdef CONFIG_HAVE_IMA_KEXEC
+#include <asm/ima.h>
+#endif
+
 enum ima_show_type { IMA_SHOW_BINARY, IMA_SHOW_BINARY_NO_FIELD_LEN,
 		     IMA_SHOW_BINARY_OLD_STRING_FMT, IMA_SHOW_ASCII };
 enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
@@ -102,6 +106,21 @@ struct ima_queue_entry {
 };
 extern struct list_head ima_measurements;	/* list of all measurements */
 
+/* Some details preceding the binary serialized measurement list */
+struct ima_kexec_hdr {
+	u16 version;
+	u16 _reserved0;
+	u32 _reserved1;
+	u64 buffer_size;
+	u64 count;
+};
+
+#ifdef CONFIG_HAVE_IMA_KEXEC
+void ima_load_kexec_buffer(void);
+#else
+static inline void ima_load_kexec_buffer(void) {}
+#endif /* CONFIG_HAVE_IMA_KEXEC */
+
 /* Internal IMA function definitions */
 int ima_init(void);
 int ima_fs_init(void);
@@ -122,6 +141,8 @@ int ima_init_crypto(void);
 void ima_putc(struct seq_file *m, void *data, int datalen);
 void ima_print_digest(struct seq_file *m, u8 *digest, u32 size);
 struct ima_template_desc *ima_template_desc_current(void);
+int ima_restore_measurement_entry(struct ima_template_entry *entry);
+int ima_restore_measurement_list(loff_t bufsize, void *buf);
 int ima_init_template(void);
 
 /*
diff -puN security/integrity/ima/ima_init.c~ima-on-soft-reboot-restore-the-measurement-list security/integrity/ima/ima_init.c
--- a/security/integrity/ima/ima_init.c~ima-on-soft-reboot-restore-the-measurement-list
+++ a/security/integrity/ima/ima_init.c
@@ -128,6 +128,8 @@ int __init ima_init(void)
 	if (rc != 0)
 		return rc;
 
+	ima_load_kexec_buffer();
+
 	rc = ima_add_boot_aggregate();	/* boot aggregate must be first entry */
 	if (rc != 0)
 		return rc;
diff -puN /dev/null security/integrity/ima/ima_kexec.c
--- /dev/null
+++ a/security/integrity/ima/ima_kexec.c
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2016 IBM Corporation
+ *
+ * Authors:
+ * Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
+ * Mimi Zohar <zohar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include "ima.h"
+
+/*
+ * Restore the measurement list from the previous kernel.
+ */
+void ima_load_kexec_buffer(void)
+{
+	void *kexec_buffer = NULL;
+	size_t kexec_buffer_size = 0;
+	int rc;
+
+	rc = ima_get_kexec_buffer(&kexec_buffer, &kexec_buffer_size);
+	switch (rc) {
+	case 0:
+		rc = ima_restore_measurement_list(kexec_buffer_size,
+						  kexec_buffer);
+		if (rc != 0)
+			pr_err("Failed to restore the measurement list: %d\n",
+				rc);
+
+		ima_free_kexec_buffer();
+		break;
+	case -ENOTSUPP:
+		pr_debug("Restoring the measurement list not supported\n");
+		break;
+	case -ENOENT:
+		pr_debug("No measurement list to restore\n");
+		break;
+	default:
+		pr_debug("Error restoring the measurement list: %d\n", rc);
+	}
+}
diff -puN security/integrity/ima/ima_queue.c~ima-on-soft-reboot-restore-the-measurement-list security/integrity/ima/ima_queue.c
--- a/security/integrity/ima/ima_queue.c~ima-on-soft-reboot-restore-the-measurement-list
+++ a/security/integrity/ima/ima_queue.c
@@ -149,3 +149,13 @@ out:
 			    op, audit_cause, result, audit_info);
 	return result;
 }
+
+int ima_restore_measurement_entry(struct ima_template_entry *entry)
+{
+	int result = 0;
+
+	mutex_lock(&ima_extend_list_mutex);
+	result = ima_add_digest_entry(entry);
+	mutex_unlock(&ima_extend_list_mutex);
+	return result;
+}
diff -puN security/integrity/ima/ima_template.c~ima-on-soft-reboot-restore-the-measurement-list security/integrity/ima/ima_template.c
--- a/security/integrity/ima/ima_template.c~ima-on-soft-reboot-restore-the-measurement-list
+++ a/security/integrity/ima/ima_template.c
@@ -37,6 +37,7 @@ static struct ima_template_field support
 	{.field_id = "sig", .field_init = ima_eventsig_init,
 	 .field_show = ima_show_template_sig},
 };
+#define MAX_TEMPLATE_NAME_LEN 15
 
 static struct ima_template_desc *ima_template;
 static struct ima_template_desc *lookup_template_desc(const char *name);
@@ -205,3 +206,172 @@ int __init ima_init_template(void)
 
 	return result;
 }
+
+static int ima_restore_template_data(struct ima_template_desc *template_desc,
+				     void *template_data,
+				     int template_data_size,
+				     struct ima_template_entry **entry)
+{
+	struct binary_field_data {
+		u32 len;
+		u8 data[0];
+	} __packed;
+
+	struct binary_field_data *field_data;
+	int offset = 0;
+	int ret = 0;
+	int i;
+
+	*entry = kzalloc(sizeof(**entry) +
+		    template_desc->num_fields * sizeof(struct ima_field_data),
+		    GFP_NOFS);
+	if (!*entry)
+		return -ENOMEM;
+
+	(*entry)->template_desc = template_desc;
+	for (i = 0; i < template_desc->num_fields; i++) {
+		field_data = template_data + offset;
+
+		/* Each field of the template data is prefixed with a length. */
+		if (offset > (template_data_size - sizeof(field_data->len))) {
+			pr_err("Restoring the template field failed\n");
+			ret = -EINVAL;
+			break;
+		}
+		offset += sizeof(field_data->len);
+
+		if (offset > (template_data_size - field_data->len)) {
+			pr_err("Restoring the template field data failed\n");
+			ret = -EINVAL;
+			break;
+		}
+		offset += field_data->len;
+
+		(*entry)->template_data[i].len = field_data->len;
+		(*entry)->template_data_len += sizeof(field_data->len);
+
+		(*entry)->template_data[i].data =
+			kzalloc(field_data->len + 1, GFP_KERNEL);
+		if (!(*entry)->template_data[i].data) {
+			ret = -ENOMEM;
+			break;
+		}
+		memcpy((*entry)->template_data[i].data, field_data->data,
+			field_data->len);
+		(*entry)->template_data_len += field_data->len;
+	}
+
+	if (ret < 0) {
+		ima_free_template_entry(*entry);
+		*entry = NULL;
+	}
+
+	return ret;
+}
+
+/* Restore the serialized binary measurement list without extending PCRs. */
+int ima_restore_measurement_list(loff_t size, void *buf)
+{
+	struct binary_hdr_v1 {
+		u32 pcr;
+		u8 digest[TPM_DIGEST_SIZE];
+		u32 template_name_len;
+		char template_name[0];
+	} __packed;
+	char template_name[MAX_TEMPLATE_NAME_LEN];
+
+	struct binary_data_v1 {
+		u32 template_data_size;
+		char template_data[0];
+	} __packed;
+
+	struct ima_kexec_hdr *khdr = buf;
+	struct binary_hdr_v1 *hdr_v1;
+	struct binary_data_v1 *data_v1;
+
+	void *bufp = buf + sizeof(*khdr);
+	void *bufendp = buf + khdr->buffer_size;
+	struct ima_template_entry *entry;
+	struct ima_template_desc *template_desc;
+	unsigned long count = 0;
+	int ret = 0;
+
+	if (!buf || size < sizeof(*khdr))
+		return 0;
+
+	if (khdr->version != 1) {
+		pr_err("attempting to restore a incompatible measurement list");
+		return 0;
+	}
+
+	/*
+	 * ima kexec buffer prefix: version, buffer size, count
+	 * v1 format: pcr, digest, template-name-len, template-name,
+	 *	      template-data-size, template-data
+	 */
+	while ((bufp < bufendp) && (count++ < khdr->count)) {
+		if (count > ULONG_MAX - 1) {
+			pr_err("attempting to restore too many measurements");
+			ret = -EINVAL;
+		}
+
+		hdr_v1 = bufp;
+		if ((hdr_v1->template_name_len >= MAX_TEMPLATE_NAME_LEN) ||
+		    ((bufp + hdr_v1->template_name_len) > bufendp)) {
+			pr_err("attempting to restore a template name \
+				that is too long\n");
+			ret = -EINVAL;
+			break;
+		}
+		bufp += sizeof(*hdr_v1);
+
+		/* template name is not null terminated */
+		memcpy(template_name, bufp, hdr_v1->template_name_len);
+		template_name[hdr_v1->template_name_len] = 0;
+
+		if (strcmp(template_name, "ima") == 0) {
+			pr_err("attempting to restore an unsupported \
+				template \"%s\" failed\n", template_name);
+			ret = -EINVAL;
+			break;
+		}
+		data_v1 = bufp += (u_int8_t)hdr_v1->template_name_len;
+
+		/* get template format */
+		template_desc = lookup_template_desc(template_name);
+		if (!template_desc) {
+			pr_err("template \"%s\" not found\n", template_name);
+			ret = -EINVAL;
+			break;
+		}
+
+		if (bufp > (bufendp - sizeof(data_v1->template_data_size))) {
+			pr_err("restoring the template data size failed\n");
+			ret = -EINVAL;
+			break;
+		}
+		bufp += (u_int8_t) sizeof(data_v1->template_data_size);
+
+		if (bufp > (bufendp - data_v1->template_data_size)) {
+			pr_err("restoring the template data failed\n");
+			ret = -EINVAL;
+			break;
+		}
+
+		ret = ima_restore_template_data(template_desc,
+						data_v1->template_data,
+						data_v1->template_data_size,
+						&entry);
+		if (ret < 0)
+			break;
+
+		memcpy(entry->digest, hdr_v1->digest, TPM_DIGEST_SIZE);
+		entry->pcr = hdr_v1->pcr;
+		ret = ima_restore_measurement_entry(entry);
+		if (ret < 0)
+			break;
+
+		bufp += data_v1->template_data_size;
+	}
+	return ret;
+}
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

ima-on-soft-reboot-restore-the-measurement-list.patch
ima-permit-duplicate-measurement-list-entries.patch
ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch
ima-on-soft-reboot-save-the-measurement-list.patch
ima-store-the-builtin-custom-template-definitions-in-a-list.patch
ima-support-restoring-multiple-template-formats.patch
ima-define-a-canonical-binary_runtime_measurements-list-format.patch

