Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EEF28A1CA
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849734; cv=none; b=BjV5f13WaL09ej48LrhGZlsa2b4FqKskm1a4dHlG1IN2ogofpdDuGkBiw6HGy3fSXZTFLHFiKldSHyfWNd43YCHc29ICLDQz7kzYWXaNbRnzQeRikp31WHQj/cEcRX37smhnl++TZ0OVQ0veAqDWBC6hVAz+3RI4O+mJw693neA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849734; c=relaxed/simple;
	bh=ZBaNymscrfa3S8+NCCKGm02n9P4UF5U9d7AsLk7lBhY=;
	h=Date:To:From:Subject:Message-Id; b=ZYAEHGP4wFZmxrBV3fT3Pqt0wbHMGHLXDIuajsG4qElyDNa7Qc4HE+90KF4cDlgeqfytcblu93u0fUzrkHukmy16yM2QuX6AWkqZVlZPWJkRYA7g1aFJ7nOfr7cXmpUS/Kar0pO58q8IY6FqS1kuoQeRNrm3yW/0H/M8a7e61OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JqzdxVmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JqzdxVmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E70C4CEE4;
	Wed, 21 May 2025 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849733;
	bh=ZBaNymscrfa3S8+NCCKGm02n9P4UF5U9d7AsLk7lBhY=;
	h=Date:To:From:Subject:From;
	b=JqzdxVmSQeyf/tnObdnwKhqyWoLueAr5XLDSPTgx0gkTInNlISVbkkGvyPkd950mD
	 gNxugTNW8HrNrMHoaIZKYkWkvvbtw1iOIkbkUXJFhcrRJPZvd+AsEl4pYmvPHQ76g1
	 gKJzRSZ29K0c81eQA6tHleYO5wydJtJzgMFN/Fo4=
Date: Wed, 21 May 2025 10:48:52 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,okozina@redhat.com,kernelfans@gmail.com,jpazdziora@redhat.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,bhe@redhat.com,berrange@redhat.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging.patch removed from -mm tree
Message-Id: <20250521174853.61E70C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash_dump: reuse saved dm crypt keys for CPU/memory hot-plugging
has been removed from the -mm tree.  Its filename was
     crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Coiby Xu <coxu@redhat.com>
Subject: crash_dump: reuse saved dm crypt keys for CPU/memory hot-plugging
Date: Fri, 2 May 2025 09:12:38 +0800

When there are CPU and memory hot un/plugs, the dm crypt keys may need to
be reloaded again depending on the solution for crash hotplug support. 
Currently, there are two solutions.  One is to utilizes udev to instruct
user space to reload the kdump kernel image and initrd, elfcorehdr and etc
again.  The other is to only update the elfcorehdr segment introduced in
commit 247262756121 ("crash: add generic infrastructure for crash hotplug
support").

For the 1st solution, the dm crypt keys need to be reloaded again.  The
user space can write true to /sys/kernel/config/crash_dm_crypt_key/reuse
so the stored keys can be re-used.

For the 2nd solution, the dm crypt keys don't need to be reloaded. 
Currently, only x86 supports the 2nd solution.  If the 2nd solution gets
extended to all arches, this patch can be dropped.

Link: https://lkml.kernel.org/r/20250502011246.99238-5-coxu@redhat.com
Signed-off-by: Coiby Xu <coxu@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jan Pazdziora <jpazdziora@redhat.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst |    4 +
 kernel/crash_dump_dm_crypt.c              |   52 ++++++++++++++++++--
 2 files changed, 52 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/kdump/kdump.rst~crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -570,6 +570,10 @@ encrypted disk volume. User space can in
     cat /sys/kernel/config/crash_dm_crypt_keys/count
     2
 
+    # To support CPU/memory hot-plugging, re-use keys already saved to reserved
+    # memory
+    echo true > /sys/kernel/config/crash_dm_crypt_key/reuse
+
 2. Load the dump-capture kernel
 
 3. After the dump-capture kerne get booted, restore the keys to user keyring
--- a/kernel/crash_dump_dm_crypt.c~crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging
+++ a/kernel/crash_dump_dm_crypt.c
@@ -28,6 +28,20 @@ static size_t get_keys_header_size(size_
 	return struct_size(keys_header, keys, total_keys);
 }
 
+static void get_keys_from_kdump_reserved_memory(void)
+{
+	struct keys_header *keys_header_loaded;
+
+	arch_kexec_unprotect_crashkres();
+
+	keys_header_loaded = kmap_local_page(pfn_to_page(
+		kexec_crash_image->dm_crypt_keys_addr >> PAGE_SHIFT));
+
+	memcpy(keys_header, keys_header_loaded, get_keys_header_size(key_count));
+	kunmap_local(keys_header_loaded);
+	arch_kexec_protect_crashkres();
+}
+
 static int read_key_from_user_keying(struct dm_crypt_key *dm_key)
 {
 	const struct user_key_payload *ukp;
@@ -150,8 +164,36 @@ static ssize_t config_keys_count_show(st
 
 CONFIGFS_ATTR_RO(config_keys_, count);
 
+static bool is_dm_key_reused;
+
+static ssize_t config_keys_reuse_show(struct config_item *item, char *page)
+{
+	return sprintf(page, "%d\n", is_dm_key_reused);
+}
+
+static ssize_t config_keys_reuse_store(struct config_item *item,
+					   const char *page, size_t count)
+{
+	if (!kexec_crash_image || !kexec_crash_image->dm_crypt_keys_addr) {
+		kexec_dprintk(
+			"dm-crypt keys haven't be saved to crash-reserved memory\n");
+		return -EINVAL;
+	}
+
+	if (kstrtobool(page, &is_dm_key_reused))
+		return -EINVAL;
+
+	if (is_dm_key_reused)
+		get_keys_from_kdump_reserved_memory();
+
+	return count;
+}
+
+CONFIGFS_ATTR(config_keys_, reuse);
+
 static struct configfs_attribute *config_keys_attrs[] = {
 	&config_keys_attr_count,
+	&config_keys_attr_reuse,
 	NULL,
 };
 
@@ -238,10 +280,12 @@ int crash_load_dm_crypt_keys(struct kima
 		return -ENOENT;
 	}
 
-	image->dm_crypt_keys_addr = 0;
-	r = build_keys_header();
-	if (r)
-		return r;
+	if (!is_dm_key_reused) {
+		image->dm_crypt_keys_addr = 0;
+		r = build_keys_header();
+		if (r)
+			return r;
+	}
 
 	kbuf.buffer = keys_header;
 	kbuf.bufsz = get_keys_header_size(key_count);
_

Patches currently in -mm which might be from coxu@redhat.com are


